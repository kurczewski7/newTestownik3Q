//
//  Speech.swift
//  testownik
//
//  Created by Slawek Kurczewski on 30/09/2021.
//  Copyright © 2021 Slawomir Kurczewski. All rights reserved.
//

import Foundation
import AVFoundation

class Speech {
    var languageId: Int = 0
    
    var contentToSpeac: [String] = []
    let synthesier = AVSpeechSynthesizer()
    
    var gender: AVSpeechSynthesisVoiceGender?
    var volume: Float = 1.0
    var rate: Float = 1.0
    
    
    
    var selectedLanguage = 0
    let language = ["pl", "en-GB","de","fr","pl"]
    
//    UserDefaults.standard.set(["es", "de", "it"], forKey: "AppleLanguages")
//    UserDefaults.standard.synchronize()
    

    let t1 = """
    W Szczebrzeszynie chrząszcz brzmi w trzcinie.
    I Szczebrzeszyn z tego słynie.
    Wół go pyta: ”Panie chrząszczu,
    Po co pan tak brzęczy w gąszczu?”.
    ”Jak to – po co? To jest praca,
    Każda praca się opłaca.”

    ”A cóż za to Pan dostaje?”.
    ”Też pytanie! Wszystkie gaje,
    Wszystkie trzciny po wsze czasy,
    Łąki, pola oraz lasy,
    Nawet rzeczki, nawet zdroje,
    Wszystko to jest właśnie moje!”
    – Jan Brzechwa ”CHRZĄSZCZ”
    """
    let t2 = """
    ROBINSON CRUSOE. I WAS born in the year 1632, in the city of York, of a
    good family, though not of that country, my father being a
    foreigner of Bremen, who settled first at Hull. He got a
    good estate by merchandise, and leaving off his trade, lived
    afterwards at York, from whence he had married my
    mother, whose relations were named Robinson, a very
    good family in that country, and from whom I was called
    Robinson Kreutznaer; but, by the usual corruption of
    words in England, we are now called - nay we call
    ourselves and write our name - Crusoe; and so my
    companions always called me.
    """
    let t3 = """
    Flüchtlinge, die Unterstützung beim Erlernen der deutschen Sprache suchen und kostenfrei Deutsch üben wollen, finden hier ab sofort eine Vielzahl von Sprachlernangeboten des Goethe-Instituts: Selbstlernkurse, Sprechübungen und Videos sowie Informationen zum Umgang mit Behörden, im Alltag oder bei der Arbeitssuche. Alle Angebote funktionieren auf Smartphones und Tablets. Ein interaktives Wortschatztraining in 16 Sprachen kann ohne Vorkenntnisse genutzt werden, zahlreiche Angebote sind begleitend zu Präsenzkursen hilfreich.
    """
    let t4 = """
    Écrivain français né à Tours en 1799, décédé à Paris en 1850, Balzac (qui ajoutera une particule à son nom en 1831) est issu de la petite bourgeoisie provinciale. Sa mère l'envoie à l'âge de huit ans chez les oratoriens de Vendôme, où il reste pensionnaire pendant six ans et semble préférer la lecture à des études qu'il achèvera cependant à Paris (1814-1816). Destiné à une carrière juridique mais passionné par la lecture de romans, il arrive à convaincre sa famille de le laisser s'essayer à l'écriture. Après avoir lu la première tragédie en vers de Balzac, Cromwell amènera un critique ami de la famille à déconseiller la carrière littéraire au jeune homme.
"""
    let t5 = """
    W nowym dwa tysice dwudziestym roku, moc uścisków, dużo zdrowia i pomysłów lecz na święta trochę słodziej nich się spełnią  marzenia, niech noc dużo życzeń spełni. Wielu sukcesów, odważnych marzeń, mądrych decyzji, satysfakcji, spokoju i pomyślności na cały nadchodzący 2020 rok. Życzenia noworoczne składa Sławomir Kurczewski")
    """

    
    func setLanguage(selectedLanguage: Int) {
        contentToSpeac.removeAll()
        contentToSpeac.append(t1)
        contentToSpeac.append(t2)
        contentToSpeac.append(t3)
        contentToSpeac.append(t4)
        contentToSpeac.append(t5)

        self.selectedLanguage = selectedLanguage
    }
    func startSpeak() {
        let utterance = AVSpeechUtterance(string: contentToSpeac[selectedLanguage])
        utterance.voice = AVSpeechSynthesisVoice(language: language[selectedLanguage]) // pl "en-GB" "en-US"
        utterance.rate = 0.5
        
        //utterance.voice?.gender = .female
        //utterance.voice = AVSpeechSynthesisVoice(identifier: "Jon")
       
        synthesier.speak(utterance)
        for rek in AVSpeechSynthesisVoice.speechVoices() {
            if rek.language == "pl-PL"   && rek.gender == .female {
                print("\n\(rek.identifier)")
                print("\n VOICES sel:  \(rek)")
                print("\nIIIIIDDDD: \(rek.identifier) and X\(rek.language.prefix(2))X and Y\(rek.name)Y")
//                print("\n VOICES:\(rek)")

            }
//            rek.name = "Zosia"
//            rek.gender
//            rek.language
//            rek.identifier
//            rek.name
//            rek.quality = .enhanced
            //print("xx:\(rek.)")
        }
    }
    func stopSpeak() {
        synthesier.stopSpeaking(at: .word)
        // synthesier.continueSpeaking()
        // synthesier.pauseSpeaking(at: AVSpeechBoundary.immediate)
    }
    func pauseSpeak() {
        synthesier.pauseSpeaking(at: AVSpeechBoundary.immediate)
    }
    func  continueSpeak() {
        synthesier.continueSpeaking()
    }
    
}
