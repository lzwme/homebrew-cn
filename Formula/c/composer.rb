class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.9.4/composer.phar"
  sha256 "d3eb5c4cb2e708267dac5f9a76d2a57b07836c7ea68783a1a02bd6d94753ea80"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "172182f2a13cf947cb30b41de2e7c071a75a98c6d384a0807929d9d6cffd8de5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "172182f2a13cf947cb30b41de2e7c071a75a98c6d384a0807929d9d6cffd8de5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "172182f2a13cf947cb30b41de2e7c071a75a98c6d384a0807929d9d6cffd8de5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fa1ebe2d156e9d3de602eedc394b257b70611de98255c3fb2812d6d38d645ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fa1ebe2d156e9d3de602eedc394b257b70611de98255c3fb2812d6d38d645ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fa1ebe2d156e9d3de602eedc394b257b70611de98255c3fb2812d6d38d645ce"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "composer.phar" => "composer"
  end

  test do
    (testpath/"composer.json").write <<~JSON
      {
        "name": "homebrew/test",
        "authors": [
          {
            "name": "Homebrew"
          }
        ],
        "require": {
          "php": ">=5.3.4"
          },
        "autoload": {
          "psr-0": {
            "HelloWorld": "src/"
          }
        }
      }
    JSON

    (testpath/"src/HelloWorld/Greetings.php").write <<~PHP
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew';
        }
      }
    PHP

    (testpath/"tests/test.php").write <<~PHP
      <?php

      // Autoload files using the Composer autoloader.
      require_once __DIR__ . '/../vendor/autoload.php';

      use HelloWorld\\Greetings;

      echo Greetings::sayHelloWorld();
    PHP

    system bin/"composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end