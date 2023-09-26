extends Node

const BookType = preload("res://Scenes/Global/BookType.gd").BookType

signal CameraLock(lock: bool)
signal Puzzle1BookPush(type: BookType, pushed: bool)