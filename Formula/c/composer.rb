class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.8.2/composer.phar"
  sha256 "9ed076041e269820c6c4223d66c5325fcaddc7f4b4317b3ba936812a965857ed"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b317ffa7697ef39d306003c9d22f0a2d50795594ec043ae6f0b169adbd3ddb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b317ffa7697ef39d306003c9d22f0a2d50795594ec043ae6f0b169adbd3ddb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b317ffa7697ef39d306003c9d22f0a2d50795594ec043ae6f0b169adbd3ddb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "94d0cce6e9a4d5b6952cac47bcb3373710a585f632337145f5833eb0d32530c7"
    sha256 cellar: :any_skip_relocation, ventura:       "94d0cce6e9a4d5b6952cac47bcb3373710a585f632337145f5833eb0d32530c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a296232a4e299987cae33db785334de042148ee0f88cd0ff0e1ffd9d38c7ad26"
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