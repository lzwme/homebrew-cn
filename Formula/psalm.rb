class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://ghproxy.com/https://github.com/vimeo/psalm/releases/download/5.11.0/psalm.phar"
  sha256 "ba48c3e937a61a3b050eee4c2b6d943eab4b78e19e6f7667e1d9e5565bc13211"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4db5dd949032be507e12a85b824c7d07382f17db367cdb7610c56a4ac910c154"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4db5dd949032be507e12a85b824c7d07382f17db367cdb7610c56a4ac910c154"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4db5dd949032be507e12a85b824c7d07382f17db367cdb7610c56a4ac910c154"
    sha256 cellar: :any_skip_relocation, ventura:        "26bb65b734058843206b153d03c6981567ae747a4bcc2ec0bf0eda78145adb79"
    sha256 cellar: :any_skip_relocation, monterey:       "26bb65b734058843206b153d03c6981567ae747a4bcc2ec0bf0eda78145adb79"
    sha256 cellar: :any_skip_relocation, big_sur:        "26bb65b734058843206b153d03c6981567ae747a4bcc2ec0bf0eda78145adb79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4db5dd949032be507e12a85b824c7d07382f17db367cdb7610c56a4ac910c154"
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
          "php": ">=7.1.3"
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