class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.6.4/composer.phar"
  sha256 "5a39f3e2ce5ba391ee3fecb227faf21390f5b7ed5c56f14cab9e1c3048bcf8b8"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0c67fc65291abff625c54f30e1a314d48f7671172ae420582408bde3e49ffe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0c67fc65291abff625c54f30e1a314d48f7671172ae420582408bde3e49ffe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0c67fc65291abff625c54f30e1a314d48f7671172ae420582408bde3e49ffe5"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c4b1a3f959adf03a482b6c263750869215a1e3fdce64caf60dc058ba3ca7532"
    sha256 cellar: :any_skip_relocation, ventura:        "3c4b1a3f959adf03a482b6c263750869215a1e3fdce64caf60dc058ba3ca7532"
    sha256 cellar: :any_skip_relocation, monterey:       "3c4b1a3f959adf03a482b6c263750869215a1e3fdce64caf60dc058ba3ca7532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c67fc65291abff625c54f30e1a314d48f7671172ae420582408bde3e49ffe5"
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