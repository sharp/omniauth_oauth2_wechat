.PHONY: clean dialyzer_warnings xref_warnings deps test

REBAR=$(PWD)/rebar
RETEST=$(PWD)/deps/retest/retest
all: compile

run:	
	ERL_LIBS=apps:deps 
	erl +K true +A 4 -name welink_media@127.0.0.1 -pa ebin -pa deps/*/ebin -pa ../rabbitmq-erlang-client/ebin/ -boot start_clean -s welink_media_app -sasl errlog_type error

compile:
	./rebar get-deps
	./rebar compile

clean:
	./rebar clean

debug:
	./rebar debug

check: debug xref dialyzer deps test

xref:
	./rebar xref

dialyzer: dialyzer_warnings
	@diff -U0 dialyzer_reference dialyzer_warnings

dialyzer_warnings:
	-@dialyzer -q -n ebin -Wunmatched_returns -Werror_handling \
	-Wrace_conditions > dialyzer_warnings

binary: VSN = $(shell ./rebar -V)
binary: clean all
	@cp rebar ../rebar.wiki/rebar
	(cd ../rebar.wiki && git commit -m "Update $(VSN)" rebar)

deps:
	./rebar get-deps

test:
	@$(REBAR) eunit
	@$(RETEST) inttest