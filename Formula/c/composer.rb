class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.7.3/composer.phar"
  sha256 "fcc02ff044b5a04fbecff0158cb6041c25e8f78ac494098736fecd2bb4f381e4"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb130dc5f4ef0af8f7cdfb7e9ce94d7252121ae8ce61b16133ed29f75a1a7c0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb130dc5f4ef0af8f7cdfb7e9ce94d7252121ae8ce61b16133ed29f75a1a7c0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb130dc5f4ef0af8f7cdfb7e9ce94d7252121ae8ce61b16133ed29f75a1a7c0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "176ce501bfcab525ef1d5fcbb81d76ceadd6af2c344d3bb05ca672067684595b"
    sha256 cellar: :any_skip_relocation, ventura:        "176ce501bfcab525ef1d5fcbb81d76ceadd6af2c344d3bb05ca672067684595b"
    sha256 cellar: :any_skip_relocation, monterey:       "176ce501bfcab525ef1d5fcbb81d76ceadd6af2c344d3bb05ca672067684595b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b5cc3a3fa0a1db534911a473785627ea87a9b1bcbf4eb2e427e3f679771ccd9"
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