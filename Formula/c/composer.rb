class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.9.1/composer.phar"
  sha256 "1f9c85291820f8496ca95cd49028002db328e7fa99b4f548e8afa7f6774540f7"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9df8d80097e6388f80dd71b314ff607aca5e2fff52a7834b15fa5640c17c86c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9df8d80097e6388f80dd71b314ff607aca5e2fff52a7834b15fa5640c17c86c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9df8d80097e6388f80dd71b314ff607aca5e2fff52a7834b15fa5640c17c86c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb13ab352fa56ba227d2cd5fdc0a280072cd4846f351f768905166b4043ad4cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb13ab352fa56ba227d2cd5fdc0a280072cd4846f351f768905166b4043ad4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb13ab352fa56ba227d2cd5fdc0a280072cd4846f351f768905166b4043ad4cf"
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