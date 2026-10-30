class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.11.0/composer.phar"
  sha256 "9674f12a2a181100d889ebfd0b4510805b3e94cea57869b14b383753d602599b"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e3bbd7b601c5365bf206020a9ccc1278a69951af1a533069d9a377e865e4e56f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3bbd7b601c5365bf206020a9ccc1278a69951af1a533069d9a377e865e4e56f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3bbd7b601c5365bf206020a9ccc1278a69951af1a533069d9a377e865e4e56f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "800721357f46ec6c5bb2d613b49cdd60f058531ecc0610cdce82b3db84784bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "800721357f46ec6c5bb2d613b49cdd60f058531ecc0610cdce82b3db84784bc2"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces the prefix with a non-default value
  on_macos do
    pour_bottle? only_if: :default_prefix
  end

  allow_network_access! :test

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