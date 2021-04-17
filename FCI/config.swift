//
//  config.swift
//  FCI
//
//  Created by Abanob Wadie on 7/28/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit

class APIs: NSObject {

    static func login() -> String {
        return "https://fciapi.herokuapp.com/api/login"
    }
    
    static func postsByLevel(userId: String, level: String) -> String {
        return "https://fciapi.herokuapp.com/api/postsByLevel/\(userId)/\(level)"
    }
    
    static func createPostByLevel() -> String {
        return "https://fciapi.herokuapp.com/api/createPostByDocOrStudent"
    }
    
    static func like() -> String {
        return "https://fciapi.herokuapp.com/api/postLike"
    }
    
    static func getcomments(userId: String, postId: String) -> String {
        return "https://fciapi.herokuapp.com/api/getComments/\(postId)/\(userId)"
    }
    
    static func CommentPost() -> String {
        return "https://fciapi.herokuapp.com/api/createComment"
    }
    
    static func likeComment() -> String {
        return "https://fciapi.herokuapp.com/api/commentLike"
    }
    
    static func replayComment() -> String {
        return "https://fciapi.herokuapp.com/api/comentReplay"
    }
    
    static func likeReplay() -> String {
        return "https://fciapi.herokuapp.com/api/replayLike"
    }
    
    static func getUserInfo(userId: String) -> String {
        return "https://fciapi.herokuapp.com/api/studentOrDocInfo/\(userId)"
    }
    
    static func updateProfileImage() -> String {
        return "https://fciapi.herokuapp.com/api/updateProfileImage"
    }
    
    static func updatePassword() -> String {
        return "https://fciapi.herokuapp.com/api/updatePassword"
    }
    
    static func getDoctors(userId: String) -> String {
        return "https://fciapi.herokuapp.com/api/doctorsByDoc/\(userId)"
    }
    
    static func getAllStudentsByDoctor(userId: String) -> String {
        return "https://fciapi.herokuapp.com/api/studentsByDoc/\(userId)"
    }
    
    static func getAllStudentsByStudent(userId: String) -> String {
        return "https://fciapi.herokuapp.com/api/students/\(userId)"
    }
    
    static func doctorsSearch() -> String {
        return "https://fciapi.herokuapp.com/api/doctorsSearch"
    }
    
    static func studentsSearchByStudent() -> String {
        return "https://fciapi.herokuapp.com/api/studentsSearch"
    }
    
    static func studentsSearchByDoctor() -> String {
        return "https://fciapi.herokuapp.com/api/studentsSearchByDoc"
    }
    
    static func getEvents() -> String {
        return "https://fciapi.herokuapp.com/api/getEvents"
    }
    
    static func getMaterialsByLevel(level: String) -> String {
        return "https://fciapi.herokuapp.com/api/getMaterial/\(level)"
    }
    
    static func getMaterialsByDoctor(userId: String) -> String {
        return "https://fciapi.herokuapp.com/api/getDoctorMaterial/\(userId)"
    }
    
    static func uploadMaterial() -> String {
        return "https://fciapi.herokuapp.com/api/uploadMaterial"
    }
    
    static func getQuizByLevel(userId: String) -> String {
        return "https://fciapi.herokuapp.com/api/quizes/\(userId)"
    }
    
    static func getQuizByDocOrDone(userId: String) -> String {
        return "https://fciapi.herokuapp.com/api/doctorUploadedQuizes/\(userId)"
    }
    
    static func addQuiz() -> String {
        return "https://fciapi.herokuapp.com/api/createQuizbyDoc"
    }
    
    static func addQuestionToQuiz() -> String {
        return "https://fciapi.herokuapp.com/api/addQuetion"
    }
    
    static func correctQuiz() -> String {
        return "https://fciapi.herokuapp.com/api/quizResult"
    }
    
    static func getAllResults(quizId: String) -> String {
        return "https://fciapi.herokuapp.com/api/getQuizResult/\(quizId)"
    }
    
    static func getTotalUnreadMessages(userId: String) -> String {
        return "https://fciapi.herokuapp.com/api/unreadMessages/\(userId)"
    }
    
    static func getContacts(userId: String) -> String {
        return "https://fciapi.herokuapp.com/api/messagesContacts/\(userId)"
    }
    
    static func getUnreadMessagesBetween2Users(firstUserId: String, secondUserId: String) -> String {
        return "https://fciapi.herokuapp.com/api/unreadMessagesBetween2Users/\(firstUserId)/\(secondUserId)"
    }
    
    static func contactsSearch() -> String {
        return "https://fciapi.herokuapp.com/api/contactsSearch"
    }
    
    static func getMesagesBetween2Users(firstUserId: String, secondUserId: String) -> String {
        return "https://fciapi.herokuapp.com/api/getMessages/\(firstUserId)/\(secondUserId)"
    }
    
    static func assignMesagesAsReaded(firstUserId: String, secondUserId: String) -> String {
        return "https://fciapi.herokuapp.com/api/readedMessges/\(firstUserId)/\(secondUserId)"
    }
    
    static func sendMessage() -> String {
        return "https://fciapi.herokuapp.com/api/addMessage"
    }
}
