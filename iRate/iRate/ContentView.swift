//
//  ContentView.swift
//  iRate
//
//  Created by Sabbir Nasir on 8/2/26.
//

import SwiftUI
struct SelectionRow: View {
    typealias Action = (String) -> Void
    
    let title: String
    @Binding var selectedItem : String?
    @Binding var showSheet : Bool
    
    var action : Action?
    var body: some View {
        HStack{
            Text(title)
            .font(.subheadline)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            showSheet = false
            if title == selectedItem{
                selectedItem = nil
            }else {
                selectedItem = title
            }
            
            //action
            if let action = action {
                action(title)
            }
        }
    }
}


struct ContentView: View {
    @State var baseAmount = "1.0"
    @State var baseCr = "BDT"
    @State var currencyList = [String]()
    @FocusState private var focusedInput: Bool
    @State var onlyCrCodes = [String]()
    @State var desCrCode = "USD"
    
    @State var currencies = [String]()
    @State var fullList = [String]()
    @State var result = ""
    @State var isPayloadCall = false
    @State var showSheet = false
    @State var showSheet2 = false
    @State var errorAlert = false
    
    var  someText = "Select Your Currency Code: "
    var alterText = "Select To the Currency Code: "
    var apiErrorText = "Api Error Occured"
    var validationErrorText = "Please enter valid input"
    
    
    @State var searchCr = ""
    @State var selectedItem: String? = nil
    
    @State var currencyCode : currencyBase?
    enum currencyBase {
        case curentCurrency, conversionCurrency
    }
    
    @State var handleError: errorType?
    enum errorType {
        case apiError, inputError
    }
    
    //function to make api request
    func validation() {
        if Double(baseAmount) ?? 0.0 <= 0{
          errorAlert = true
            handleError = .inputError
        }else if baseAmount.hasPrefix("."){
            baseAmount = "0"+"\(baseAmount)"
            makeRequest()
        }else{
            makeRequest()
        }
    }
    
    func makeRequest (){
        isPayloadCall = true
        onlyCrCodes.removeAll()
        currencies.removeAll()
        fullList.removeAll() //front page code + value
        currencyList.removeAll()
        currencies.append(desCrCode)
        
        apiRequest(url: "https://v6.exchangerate-api.com/v6/80a68197fb86c8427589c1a4/latest/\(baseCr)/\(desCrCode)"){ currencyData in
        
            if let currency = currencyData{
                for currency in  currency.rates {
                    onlyCrCodes.append(currency.key)
                    fullList.append("\(currency.key) \(String (format: "%.2f", currency.value))")
                    
                    if currencies.contains(currency.key){
                        result = "\(currency.key) \(String (format: "%.2f", currency.value))"
                    }
                    
                    onlyCrCodes.sort()
                    fullList.sort()
                    
                }
                isPayloadCall = false
                errorAlert = !currency.success
                handleError = .apiError
                
            }
        }
    }

    var body: some View {
        ZStack{
            
            VStack{
                HStack{
                    Text("Currency Converter")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.pink)
                }
                .padding(.bottom,40)
                
                HStack(spacing: 40){
                    VStack{
                        Text("Your currency: ")
                            .padding(.top,10)
                            .padding(.horizontal)
                        
                        HStack{
                            Text(baseCr)
                                .foregroundColor(.blue)
                            Image(systemName: "arrowshape.turn.up.right")
                                .foregroundColor(.blue)
                        }
                        .padding(.top,6)
                        .padding(.bottom,10)
                        
                        .onChange(of: baseCr){ newValue in
                           validation()
                        }
                    }
                    .background(Color("CellBackground"))
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 2, y: 2)
                    .onTapGesture {
                        showSheet = true
                        currencyCode = .curentCurrency
                        focusedInput = false
                        
                    }
                    VStack{
                        Text("To the currency: ")
                            .padding(.top,10)
                            .padding(.horizontal)
                        HStack{
                            Text(desCrCode)
                                .foregroundColor(.blue)
                            Image(systemName: "arrowshape.turn.up.right")
                                .foregroundColor(.blue)
                        }
                        .padding(.top,6)
                        .padding(.bottom,10)
                        
                        .onChange(of: desCrCode){ newValue in
                          validation()
                            
                        }
                    }
                    .background(Color("CellBackground"))
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 2, y: 2)
                    .onTapGesture {
                        showSheet = true
                        currencyCode = .conversionCurrency
                        focusedInput = true
                    }
                }
                .padding(.bottom,10)
                
                Section{
                    TextField("Enter an amount: ", text: $baseAmount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.10))
                        .cornerRadius(10)
                        .padding(20)
                        .onChange(of: baseAmount){ newValue in
                          validation()
                            
                        }
                        .focused($focusedInput)
                }
                VStack{
                    Text("Converted Currency: ")
                        .bold()
                        .font(.title2)
                    Text(result)
                        .bold()
                        .font(.title3)
                        .foregroundColor(Color("ConvertColor"))
                }
                
                List{
                    ForEach(fullList, id: \.self){ currency in
                        Text("Converted Currency: "+currency)
                            .font(.subheadline)
                    }
                }
                
                .onAppear{
                    validation()
                }
            }
            .padding(.top, 50)
            .padding(.bottom, 1)
            
            
            if isPayloadCall == true{
                ZStack{
                    Color.black.opacity(0.3)
                    ActivityIndicator(isAnimating: $isPayloadCall, style: .large, color: .white)
                }
                
            }
            
            if showSheet == true{
                ZStack{
                    VStack(spacing: 0){
                        HStack{
                            Color.black.opacity(0.3)
                        }
                        
                        .frame(height: UIScreen.main.bounds.height*0.3)
                        
                        .onTapGesture {
                            showSheet = false
                            searchCr = ""
                        }
                        
                        ZStack{
                            VStack(spacing:8){
                                Text(currencyCode == .curentCurrency ? someText : alterText)
                                    .padding()
                                    .font(.headline)
                                    .bold()
                                TextField("Search here", text: $searchCr)
                                    .keyboardType(.default)
                                    .padding(.horizontal,20)
                                    .frame(height: 40)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding(.top,20)
                                
                                List{
                                    
                                    ForEach( searchCr.isEmpty ? onlyCrCodes :  onlyCrCodes.filter({$0.lowercased().contains(searchCr.lowercased())}), id: \.self){ currency in
                                        
                                        SelectionRow(title: currency, selectedItem: $selectedItem, showSheet: $showSheet)
                                        { title in
                                    
                                            if currencyCode == .curentCurrency{
                                                baseCr = title
                                                searchCr=""
                                            }
                                            else {
                                                desCrCode = title
                                                searchCr = ""
                                            }
                                        }
                                    }
                                }
                            }
                            .background(Color(UIColor.systemGray6))
                        }
                    }
                }
                .ignoresSafeArea()
                .padding(.bottom,1)
            }
            
            if errorAlert == true{
                VStack(alignment: .center){
                    
                }
                .toast(showToast: $errorAlert,position: .middle, toastContent: {
                    Text(handleError == .apiError ? apiErrorText : validationErrorText)
                })
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        errorAlert = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



