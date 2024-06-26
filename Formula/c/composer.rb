class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.7.7/composer.phar"
  sha256 "06e4c4bc6d32b8975174f4f4a0a93476d8907da92a1484c5a8ef138897a760e1"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d264eb28793c24048c9a480b5cb358ea3e3f9ccea9c50a55ddbe1e12007f9a3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d264eb28793c24048c9a480b5cb358ea3e3f9ccea9c50a55ddbe1e12007f9a3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d264eb28793c24048c9a480b5cb358ea3e3f9ccea9c50a55ddbe1e12007f9a3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ed6356bcc98404d24569a5118a210c4565bee482957b3345829a6d2ec17ffb4"
    sha256 cellar: :any_skip_relocation, ventura:        "8ed6356bcc98404d24569a5118a210c4565bee482957b3345829a6d2ec17ffb4"
    sha256 cellar: :any_skip_relocation, monterey:       "8ed6356bcc98404d24569a5118a210c4565bee482957b3345829a6d2ec17ffb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4aac9ce1fd5c7801426be40e622ebbd1b844d7bbd78c4a15ac6cc8ba7ea9b3b"
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