class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.7.5/composer.phar"
  sha256 "0dc1f6bcb7a26ee165206010213c6069a537bf8e6533528739a864f154549b77"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0013bf3fbbed1f99eb0469a9a27b0d58f882ae8b9c4fb1783744bae8ba7b744"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0013bf3fbbed1f99eb0469a9a27b0d58f882ae8b9c4fb1783744bae8ba7b744"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0013bf3fbbed1f99eb0469a9a27b0d58f882ae8b9c4fb1783744bae8ba7b744"
    sha256 cellar: :any_skip_relocation, sonoma:         "2418b61920fd29ad32fcd0d5a37e909efcf64f6c5df585a4d46c39266092cc8d"
    sha256 cellar: :any_skip_relocation, ventura:        "2418b61920fd29ad32fcd0d5a37e909efcf64f6c5df585a4d46c39266092cc8d"
    sha256 cellar: :any_skip_relocation, monterey:       "2418b61920fd29ad32fcd0d5a37e909efcf64f6c5df585a4d46c39266092cc8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "829dcf3a6118b5b420bfb7a0ec833bccd3df93d0c425287e2f491efc89b5470d"
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