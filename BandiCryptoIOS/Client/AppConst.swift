//
//  AppConst.swift
//  BandiCryptoIOS
//
//  Created by bandisnc on 1/8/24.
//

import Foundation

public class AppConst {
    public init() {
        
    }
    
    public static let clientHostName = "bs_res_url"
    
    public static let requestFnName = "bs_req_fn"

    // 호출 APP 서버 url
    public static let serverUrlName = "bs_surl"

    // 응답 값 타입
    public static let resTypeName = "bs_res_ty"

    // 응답 값
    public static let resDataName = "bs_res_dt"

    // 아이디
    public static let userIdName = "bs_id"

    // 커스텀 파라미터
    public static let customName = "bs_cus_prm"

    // 응답 타입
    public static let resTypeEncJson = "enc_json"
    public static let resTypeJson = "json"
    public static let resTypeQuery = "query"
    
    // 인코딩
    public static let BASE64 = "BASE64"
    public static let BASE64URL = "BASE64URL"
    public static let HEX = "HEX"
    
}
