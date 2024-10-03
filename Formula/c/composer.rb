class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.8.0/composer.phar"
  sha256 "1b23f2a31cb05f0e8ae29b5723fc5edf37e565106d6fae2cf23f298efa9c8981"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8c75c20991e8390ef273fae1764a4628d8836a76c8b217debb32ca4ad410703"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8c75c20991e8390ef273fae1764a4628d8836a76c8b217debb32ca4ad410703"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8c75c20991e8390ef273fae1764a4628d8836a76c8b217debb32ca4ad410703"
    sha256 cellar: :any_skip_relocation, sonoma:        "1be612fe9af4440020fb63fca6cd9746f617c263bac2d52cbe0af363e7005bb8"
    sha256 cellar: :any_skip_relocation, ventura:       "1be612fe9af4440020fb63fca6cd9746f617c263bac2d52cbe0af363e7005bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e161b10526a684bcbdf0540a00494361bbac6ab4982da4d1ed6bdc571be4c8ee"
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