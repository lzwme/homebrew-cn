class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.9.5psalm.phar"
  sha256 "a3bb23a3518d7b8edf7f3a0f1f597e58644f5d36569bc09dd94a555626e2406e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aea893a856e6b9b695215aad1934781c18ed07c5bf5d4bb094dc05939316c81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aea893a856e6b9b695215aad1934781c18ed07c5bf5d4bb094dc05939316c81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5aea893a856e6b9b695215aad1934781c18ed07c5bf5d4bb094dc05939316c81"
    sha256 cellar: :any_skip_relocation, sonoma:        "a999ac47ee10727c3ed6c494d3dd441934720a8f9e61501dd59cdf98f0b79f17"
    sha256 cellar: :any_skip_relocation, ventura:       "a999ac47ee10727c3ed6c494d3dd441934720a8f9e61501dd59cdf98f0b79f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aea893a856e6b9b695215aad1934781c18ed07c5bf5d4bb094dc05939316c81"
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