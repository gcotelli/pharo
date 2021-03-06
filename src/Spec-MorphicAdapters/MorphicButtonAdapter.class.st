"
SpecInterpreter
	interpretASpec: MorphicButtonAdapter  defaultSpec
	model: (MorphicButtonAdapter model: ButtonPresenter new)

"
Class {
	#name : #MorphicButtonAdapter,
	#superclass : #AbstractMorphicAdapter,
	#category : #'Spec-MorphicAdapters-Base'
}

{ #category : #'widget API' }
MorphicButtonAdapter >> action [

	self widget ifNotNil: [:m | m takeKeyboardFocus ].
	self model performAction.
]

{ #category : #protocol }
MorphicButtonAdapter >> askBeforeChanging [

	^ self model askBeforeChanging
]

{ #category : #private }
MorphicButtonAdapter >> buildLabel: text withIcon: icon [

	icon ifNil: [ ^ text
			ifNil: [ '' ]
			ifNotNil: [ text ] ].
	
	^ IconicListItem 
		text: text 
		icon: icon

]

{ #category : #factory }
MorphicButtonAdapter >> buildWidget [
	
	| button normalColorBlock clickedColorBlock | 
	button := PluggableButtonMorph
				on: self 
				getState: #state 
				action:  #action 
				label: #label 
				menu: nil. 	
	button 
		getEnabledSelector: #enabled ;
		getFontSelector: #font ;
		hResizing: #spaceFill ;
		vResizing: #spaceFill ;
		askBeforeChanging: self askBeforeChanging ;
		setBalloonText: self model help ;
		dragEnabled: self dragEnabled;
		dropEnabled: self dropEnabled ;	
		eventHandler: (MorphicEventHandler new on: #keyStroke send: #keyStroke:fromMorph: to: self).
	
	normalColorBlock := [ :aButton |
							(aButton valueOfProperty: #noFill ifAbsent: [false]) 
								ifTrue: [ SolidFillStyle color: Color transparent ]
								ifFalse: [ SolidFillStyle color: self color ] ].
	clickedColorBlock := [ :aButton | SolidFillStyle color: self color muchDarker ].
	button theme: ((UIThemeDecorator theme: button theme)
							property: #buttonNormalFillStyleFor: returnsValueOf: normalColorBlock;
							property: #buttonMouseOverFillStyleFor: returnsValueOf: normalColorBlock;
							property: #buttonPressedFillStyleFor: returnsValueOf: clickedColorBlock;
							yourself).
	^ button
]

{ #category : #'widget API' }
MorphicButtonAdapter >> font [
	^self model font
]

{ #category : #'widget API' }
MorphicButtonAdapter >> keyStroke: anEvent fromMorph: aMorph [
]

{ #category : #'widget API' }
MorphicButtonAdapter >> label [
	
	^ self buildLabel: self model label withIcon: self model icon
]

{ #category : #'widget API' }
MorphicButtonAdapter >> menu: aMenu [
	| menuModel |
	
	menuModel := self model menu.
	menuModel isBlock ifTrue: [ menuModel := menuModel value ].
	^ menuModel buildWithSpec
]

{ #category : #'widget API' }
MorphicButtonAdapter >> state [

	^ self model state
]
