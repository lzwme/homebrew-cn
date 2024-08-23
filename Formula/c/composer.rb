class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.7.8/composer.phar"
  sha256 "3da35dc2abb99d8ef3fdb1dec3166c39189f7cb29974a225e7bbca04c1b2c6e0"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5148b8a7afe35f524788b1a98db196e521faee13b398ec36d5aee15e6c9551d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5148b8a7afe35f524788b1a98db196e521faee13b398ec36d5aee15e6c9551d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5148b8a7afe35f524788b1a98db196e521faee13b398ec36d5aee15e6c9551d"
    sha256 cellar: :any_skip_relocation, sonoma:         "66e14152bdb1ed230aa4627e067cc552fe60214753163b648230534d6e5afbf1"
    sha256 cellar: :any_skip_relocation, ventura:        "66e14152bdb1ed230aa4627e067cc552fe60214753163b648230534d6e5afbf1"
    sha256 cellar: :any_skip_relocation, monterey:       "66e14152bdb1ed230aa4627e067cc552fe60214753163b648230534d6e5afbf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbe67557887b2e8efa0e4191f8ec8df236f68d386d257b7348d7cebce0fafcd7"
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