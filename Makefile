#####################################################################
#-----|                  Edsger Makefile                      #-----|
#-----|                                                       #-----|
#####################################################################

#####################################################################
#| Compiler Specific Variables
#####################################################################

EXENAME       = Compiler
EXE_FULL_PATH = ./$(EXENAME)
FLAGS         = -r -use-menhir -tag 'debug,thread' -use-ocamlfind -quiet
PACKAGES      = -pkgs 'core'
# add if needed: ppx_deriving,ppx_deriving.show

#####################################################################
#| Refer to the following link for more info about ocamlbuild
#| https://github.com/ocaml/ocamlbuild/blob/master/manual/manual.adoc
#####################################################################

$(EXENAME): Parser.mly Lexer.mll $(wildcard *.ml) $(wildcard *.mli)
	ocamlbuild $(FLAGS) $(PACKAGES) $(EXENAME).native
	mv $(EXENAME).native $(EXENAME)

#####################################################################
#######| Helping Targets 
#####################################################################

.PHONY: clean test ftest

clean:
	$(RM) **/*.o **/*.a
	$(RM) *.cmo *.cmi *~ 
	$(RM) Lexer.ml 
	$(RM) Parser.ml Parser.mli
	$(RM) Parser.automaton Parser.conflicts Parser.output
	$(RM) -rf Compiler _build

#####################################################################
#######| Testing Targets 
#####################################################################

TESTINPUT  = _test/input/

TEST_LW  := $(wildcard $(TESTINPUT)lexer*w.txt)
TEST_PW  := $(wildcard $(TESTINPUT)parser*w.txt)
TEST_PC  := $(wildcard $(TESTINPUT)parser*c.txt)
TEST_SW  := $(wildcard $(TESTINPUT)semantic*w.txt)
TEST_SC  := $(wildcard $(TESTINPUT)semantic*c.txt)

TESTING_COMMAND = bash ./_test/Test.sh
UNIT_TEST_COMMAND = bash ./OutputTest.sh

test: Compiler  # Test for errors
	@printf "LEXER:\n"
	@$(TESTING_COMMAND) $(EXE_FULL_PATH) 1 -eq $(TEST_LW) 
	@printf "PARSER:\n"
	@$(TESTING_COMMAND) $(EXE_FULL_PATH) 2 -eq $(TEST_PW)
	@$(TESTING_COMMAND) $(EXE_FULL_PATH) 2 -lt $(TEST_PC)
	@printf "SEMANTIC:\n"
	@$(TESTING_COMMAND) $(EXE_FULL_PATH) 3 -eq $(TEST_SW)
	@$(TESTING_COMMAND) $(EXE_FULL_PATH) 0 -eq $(TEST_SC)
	@printf "Unit Tests:\n"
	@$(UNIT_TEST_COMMAND)
# TODO check if this could be done better than simply executing

#####################################################################
#-----|                        THE END                        #-----|
#####################################################################
