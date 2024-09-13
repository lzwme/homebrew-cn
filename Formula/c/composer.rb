class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.7.9/composer.phar"
  sha256 "b6de5e65c199d80ba11897fbe1364e063e858d483f6a81a176c4d60f2b1d6347"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c3a13e9e93b6f820869237b0b7f0c6ca860328fc8b99a1e1bb53e950f6f4c833"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3a13e9e93b6f820869237b0b7f0c6ca860328fc8b99a1e1bb53e950f6f4c833"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3a13e9e93b6f820869237b0b7f0c6ca860328fc8b99a1e1bb53e950f6f4c833"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3a13e9e93b6f820869237b0b7f0c6ca860328fc8b99a1e1bb53e950f6f4c833"
    sha256 cellar: :any_skip_relocation, sonoma:         "489407d1634e9f7339702cc61d29821fd4e1333007823a822431e3375f6e0d03"
    sha256 cellar: :any_skip_relocation, ventura:        "489407d1634e9f7339702cc61d29821fd4e1333007823a822431e3375f6e0d03"
    sha256 cellar: :any_skip_relocation, monterey:       "489407d1634e9f7339702cc61d29821fd4e1333007823a822431e3375f6e0d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9b6a2dc470f366817003d4d8d5f19c816dd49938a0558429910ccb958da4ffe"
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
    (testpath/"composer.json").write <<~EOS
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
    EOS

    (testpath/"src/HelloWorld/Greetings.php").write <<~EOS
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew';
        }
      }
    EOS

    (testpath/"tests/test.php").write <<~EOS
      <?php

      // Autoload files using the Composer autoloader.
      require_once __DIR__ . '/../vendor/autoload.php';

      use HelloWorld\\Greetings;

      echo Greetings::sayHelloWorld();
    EOS

    system bin/"composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end