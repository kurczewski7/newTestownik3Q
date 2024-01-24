//
//  TestResult.swift
//  testownik
//
//  Created by Sławek K on 09/05/2022.
//  Copyright © 2022 Slawomir Kurczewski. All rights reserved.
//

import Foundation

class TestResult {
    var errorMultiple = 2
    private(set) var fileNumber: Int  // Not to modyfy
    private(set) var goodAnswers = 777
    private(set) var wrongAnswers = 666
    var correctionsToDo = 0
    var repetitionsToDo = 0
    var lastAnswer: Bool {
        didSet {
            if lastAnswer {
                self.goodAnswers += 1
                if self.correctionsToDo == 0 {
                    self.repetitionsToDo -= (self.repetitionsToDo > 0 ? 1 : 0)
                }
                else {
                    self.correctionsToDo -= 1
                }
            }
            else {
                self.wrongAnswers += 1
                self.correctionsToDo += errorMultiple
            }
        }
    }
    // MARK: Init params: fileNumber, lastAnswer
    init(_ fileNumber: Int, lastAnswer: Bool) {
        self.fileNumber = fileNumber
        self.lastAnswer = lastAnswer
    }
    func resetAnswer() {
        self.goodAnswers = 0
        self.wrongAnswers = 0
    }
    func resetAll() {
        self.goodAnswers = 0
        self.wrongAnswers = 0
        self.correctionsToDo = 0
        self.repetitionsToDo = 0
    }
    func setFileNumber(_ fileNumber: Int ) {
        self.fileNumber = fileNumber
    }
    func setWrongAnswers(_ wrongAnswers: Int ) {
        self.wrongAnswers = wrongAnswers
    }
    func setGoodAnswers(_ goodAnswers: Int ) {
        self.goodAnswers = goodAnswers
    }
}
