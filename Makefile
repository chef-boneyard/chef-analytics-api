all: bundle test

bundle:
	bundle install
test:
	bundle exec rspec spec/ --color
