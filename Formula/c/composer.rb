class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.8.3/composer.phar"
  sha256 "8323b4105c6e166d47c9db93209370083f9e421743636e108c37d8c1126386ef"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffcd50d18b94306ee3e0d3344c272a0fb12976a32a2499e8e75b6f273b63472b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffcd50d18b94306ee3e0d3344c272a0fb12976a32a2499e8e75b6f273b63472b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffcd50d18b94306ee3e0d3344c272a0fb12976a32a2499e8e75b6f273b63472b"
    sha256 cellar: :any_skip_relocation, sonoma:        "98ffb3f3898a862ae5e787791d88dd62558ec1472e4b07f6cb48e57043589fe2"
    sha256 cellar: :any_skip_relocation, ventura:       "98ffb3f3898a862ae5e787791d88dd62558ec1472e4b07f6cb48e57043589fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566125d44a96734436a0ca4a10d1b29629f81a24db702d221f1adab818569be1"
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