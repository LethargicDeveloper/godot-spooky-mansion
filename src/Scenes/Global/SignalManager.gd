extends Node

const BookType = preload("res://Scenes/Global/BookType.gd").BookType

signal LockScreen(lock: bool)
signal CameraLock(lock: bool)
signal Puzzle1BookPush(type: BookType, pushed: bool)
signal KeyStatus(pick: bool)
signal GameOver()

var puzzle3_complete = false
