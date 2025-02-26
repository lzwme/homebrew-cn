class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.8.6/composer.phar"
  sha256 "becc28b909d2cca563e7caee1e488063312af36b1f2e31db64f417723b8c4026"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "215bc896779777242325b4cfa38c97b0eaa65767fdc04e6a4971a518d33505f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "215bc896779777242325b4cfa38c97b0eaa65767fdc04e6a4971a518d33505f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "215bc896779777242325b4cfa38c97b0eaa65767fdc04e6a4971a518d33505f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fd433d07f43db80d75980231426571f4555235e52509384c5537ad51457bf05"
    sha256 cellar: :any_skip_relocation, ventura:       "2fd433d07f43db80d75980231426571f4555235e52509384c5537ad51457bf05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdc73a48be1847bcd8e214c4e889289653ec7398a15f220f86664c8419eb717c"
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