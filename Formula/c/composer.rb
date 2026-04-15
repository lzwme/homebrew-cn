class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.9.7/composer.phar"
  sha256 "d3c6801ea6e5dd291d0f149295a4d0f1539a74d5231958fe8fdaa889a497e6cf"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a80f6f3a1c84e2595cd19eae297e3b7c9024f62cf618890b9ae1e7ac5c1b23a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a80f6f3a1c84e2595cd19eae297e3b7c9024f62cf618890b9ae1e7ac5c1b23a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a80f6f3a1c84e2595cd19eae297e3b7c9024f62cf618890b9ae1e7ac5c1b23a"
    sha256 cellar: :any_skip_relocation, sonoma:        "df6be3d8b4c58f2bf96e0b57c51b67def1f6223978b289d7a7f33fe4bd3cfa55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df6be3d8b4c58f2bf96e0b57c51b67def1f6223978b289d7a7f33fe4bd3cfa55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df6be3d8b4c58f2bf96e0b57c51b67def1f6223978b289d7a7f33fe4bd3cfa55"
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