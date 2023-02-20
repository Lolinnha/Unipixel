extends Node

# idioma escolhido
var language = OS.get_locale()

# configuração de idiomas
var locale = {}
var availableLanguages = []
# nomes de personagens
var characters = {}
# falas
var dialogs = {}
# textos de botões
var buttons = {}
# nomes de levels
var levels = []
# textos da prancheta
var clipboard = {}


func getAvailableLanguages():
	# retorna os idiomas disponíveis
	# limpa a lista de idiomas disponíveis
	availableLanguages = []
	# verifica os arquivos disponíveis na pasta de idiomas
	var localesDirectory = Directory.new()
	localesDirectory.open('res://locales/')
	localesDirectory.list_dir_begin()
	var file = localesDirectory.get_next()
	
	# passa arquivo por arquivo dentro da pasta
	while file != '':
		if (file.ends_with('.json')):
			# se for um arquivo de json, adiciona como idioma disponível
			availableLanguages.append(file.replace('.json', ''))

		file = localesDirectory.get_next()

	return availableLanguages


func loadLanguage():
	# lê e carrega o arquivo de idioma
	var file = File.new()
	file.open('res://locales/' + language + '.json', File.READ)
	locale = parse_json(file.get_as_text())
	file.close()
	
	# carrega os idiomas por categoria
	characters = locale.characters
	dialogs = locale.dialogs
	buttons = locale.buttons
	levels = locale.levels
	clipboard = locale.clipboard


func _ready():
	loadLanguage()
