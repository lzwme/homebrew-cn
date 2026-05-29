class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.10.0/composer.phar"
  sha256 "a346538851988ead111d11e3cbd7d372eeba44abd0af412e09890d3c21ea6c31"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0557884e89755a622a5e10993523c06ee4a6714750f16a044fb28d197ff55a33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0557884e89755a622a5e10993523c06ee4a6714750f16a044fb28d197ff55a33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0557884e89755a622a5e10993523c06ee4a6714750f16a044fb28d197ff55a33"
    sha256 cellar: :any_skip_relocation, sonoma:        "76cccd521b44c70212669587181f23cc8943023cfb21c64f83661c41ed76dd11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76cccd521b44c70212669587181f23cc8943023cfb21c64f83661c41ed76dd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76cccd521b44c70212669587181f23cc8943023cfb21c64f83661c41ed76dd11"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces the prefix with a non-default value
  on_macos do
    pour_bottle? only_if: :default_prefix
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