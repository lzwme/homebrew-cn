class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.6.1/composer.phar"
  sha256 "216bd5a516b544783fdce1a9e3a1eeb41f0aa9f0edb20dcd04f2846df64d3661"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e92444f90c935ae5a39c842748f81ec33eb6df64a484f4ff567f13e34ec9ce1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e92444f90c935ae5a39c842748f81ec33eb6df64a484f4ff567f13e34ec9ce1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e92444f90c935ae5a39c842748f81ec33eb6df64a484f4ff567f13e34ec9ce1f"
    sha256 cellar: :any_skip_relocation, ventura:        "ede65edc30fa6cb16e78dbdc61db4523432d36ff07ae3217666145c6209b7459"
    sha256 cellar: :any_skip_relocation, monterey:       "ede65edc30fa6cb16e78dbdc61db4523432d36ff07ae3217666145c6209b7459"
    sha256 cellar: :any_skip_relocation, big_sur:        "ede65edc30fa6cb16e78dbdc61db4523432d36ff07ae3217666145c6209b7459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e92444f90c935ae5a39c842748f81ec33eb6df64a484f4ff567f13e34ec9ce1f"
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

    system "#{bin}/composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end