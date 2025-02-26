class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.8.8psalm.phar"
  sha256 "eeb7a8fcb808747709ab0ae1c1e8419be101226f50d999f72cabf09efd9ac7ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "202ff60d8109cfbfa1e10d0b04fbe2f5e22b99df3f90222c0a76e72e24c092a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "202ff60d8109cfbfa1e10d0b04fbe2f5e22b99df3f90222c0a76e72e24c092a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "202ff60d8109cfbfa1e10d0b04fbe2f5e22b99df3f90222c0a76e72e24c092a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "52335f2e16cacb2972f19e5a324ec96436f080c2dad1d0e38a72f488b6c0e11d"
    sha256 cellar: :any_skip_relocation, ventura:       "52335f2e16cacb2972f19e5a324ec96436f080c2dad1d0e38a72f488b6c0e11d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "202ff60d8109cfbfa1e10d0b04fbe2f5e22b99df3f90222c0a76e72e24c092a6"
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