class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.6.1psalm.phar"
  sha256 "d9f2ce481118e33753d74e6cdcdadd23fde1e02f634a959862c15e84bdcc663e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d534ef225beef0f89b6ab56ab8b1fdd0fd720a60848ac39ca1489c9dd76d00f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d534ef225beef0f89b6ab56ab8b1fdd0fd720a60848ac39ca1489c9dd76d00f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d534ef225beef0f89b6ab56ab8b1fdd0fd720a60848ac39ca1489c9dd76d00f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3edaf0b77b955110a93a5b2e45a8367e88f53d68e9d7036a2c087a175c65bce6"
    sha256 cellar: :any_skip_relocation, ventura:       "3edaf0b77b955110a93a5b2e45a8367e88f53d68e9d7036a2c087a175c65bce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d534ef225beef0f89b6ab56ab8b1fdd0fd720a60848ac39ca1489c9dd76d00f4"
  end

  depends_on "composer" => :test
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `usrlocal` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    libexec.install "psalm.phar" => "psalm"

    (bin"psalm").write <<~EOS
      #!#{Formula["php"].opt_bin}php
      <?php require '#{libexec}psalm';
    EOS
  end

  test do
    (testpath"composer.json").write <<~JSON
      {
        "name": "homebrewpsalm-test",
        "description": "Testing if Psalm has been installed properly.",
        "type": "project",
        "require": {
          "php": ">=8.1"
        },
        "license": "MIT",
        "autoload": {
          "psr-4": {
            "Homebrew\\\\PsalmTest\\\\": "src"
          }
        },
        "minimum-stability": "stable"
      }
    JSON

    (testpath"srcEmail.php").write <<~PHP
      <?php
      declare(strict_types=1);

      namespace Homebrew\\PsalmTest;

      final class Email
      {
        private string $email;

        private function __construct(string $email)
        {
          $this->ensureIsValidEmail($email);

          $this->email = $email;
        }

        **
        * @psalm-suppress PossiblyUnusedMethod
        *
        public static function fromString(string $email): self
        {
          return new self($email);
        }

        public function __toString(): string
        {
          return $this->email;
        }

        private function ensureIsValidEmail(string $email): void
        {
          if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new \\InvalidArgumentException(
              sprintf(
                '"%s" is not a valid email address',
                $email
              )
            );
          }
        }
      }
    PHP

    system "composer", "install"

    assert_match "Config file created successfully. Please re-run psalm.",
                 shell_output("#{bin}psalm --init")
    system bin"psalm", "--no-progress"
  end
end