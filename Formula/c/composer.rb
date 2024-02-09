class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.7.0/composer.phar"
  sha256 "2fc501cbef1891379523ee4989d37bf04798415a05f8eb44ae75acb2fdf2596f"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78304915ba283fe4e4436c2b2d3b18092e25441b563199b24136158fd500f5a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78304915ba283fe4e4436c2b2d3b18092e25441b563199b24136158fd500f5a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78304915ba283fe4e4436c2b2d3b18092e25441b563199b24136158fd500f5a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "878e83c1fa075b61a5c93c578d9455467949c0bdde1920682eb8437c19290d07"
    sha256 cellar: :any_skip_relocation, ventura:        "878e83c1fa075b61a5c93c578d9455467949c0bdde1920682eb8437c19290d07"
    sha256 cellar: :any_skip_relocation, monterey:       "878e83c1fa075b61a5c93c578d9455467949c0bdde1920682eb8437c19290d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78304915ba283fe4e4436c2b2d3b18092e25441b563199b24136158fd500f5a3"
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