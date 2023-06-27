class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://ghproxy.com/https://github.com/vimeo/psalm/releases/download/5.13.0/psalm.phar"
  sha256 "f8650fe2d46ed64df4f826b2c84be5cfeb1aaed7cff9c35f909fb410512d73af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67acb8c6e4cd81af7af07de9830a49fb80437a4ccd0331fbf87d2a87011fc6ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67acb8c6e4cd81af7af07de9830a49fb80437a4ccd0331fbf87d2a87011fc6ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67acb8c6e4cd81af7af07de9830a49fb80437a4ccd0331fbf87d2a87011fc6ce"
    sha256 cellar: :any_skip_relocation, ventura:        "3a61c12d447448cdaa74a644d28e764ce58c9ddcb19dd0e14aa637c2c9f4ce7a"
    sha256 cellar: :any_skip_relocation, monterey:       "3a61c12d447448cdaa74a644d28e764ce58c9ddcb19dd0e14aa637c2c9f4ce7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a61c12d447448cdaa74a644d28e764ce58c9ddcb19dd0e14aa637c2c9f4ce7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67acb8c6e4cd81af7af07de9830a49fb80437a4ccd0331fbf87d2a87011fc6ce"
  end

  depends_on "composer" => :test
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "psalm.phar" => "psalm"
  end

  test do
    (testpath/"composer.json").write <<~EOS
      {
        "name": "homebrew/psalm-test",
        "description": "Testing if Psalm has been installed properly.",
        "type": "project",
        "require": {
          "php": ">=8.1"
        },
        "license": "MIT",
        "autoload": {
          "psr-4": {
            "Homebrew\\\\PsalmTest\\\\": "src/"
          }
        },
        "minimum-stability": "stable"
      }
    EOS

    (testpath/"src/Email.php").write <<~EOS
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

        /**
        * @psalm-suppress PossiblyUnusedMethod
        */
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
    EOS

    system "composer", "install"

    assert_match "Config file created successfully. Please re-run psalm.",
                 shell_output("#{bin}/psalm --init")
    assert_match "No errors found!",
                 shell_output("#{bin}/psalm")
  end
end