class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://ghproxy.com/https://github.com/vimeo/psalm/releases/download/5.10.0/psalm.phar"
  sha256 "366521b7c6aa567fc4bfd1d42f7cdb8c43e7931709573bd01b9ae0a5deba830a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6566d0cc17c513ca48a323cd2ebdafecfb71ba6bbaddfe2f7de8bbbdd42fcc16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6566d0cc17c513ca48a323cd2ebdafecfb71ba6bbaddfe2f7de8bbbdd42fcc16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6566d0cc17c513ca48a323cd2ebdafecfb71ba6bbaddfe2f7de8bbbdd42fcc16"
    sha256 cellar: :any_skip_relocation, ventura:        "cabf7057ea02e145ccbf6482079c532e4c60ac96727b6068c98f6c4ed3185fc4"
    sha256 cellar: :any_skip_relocation, monterey:       "cabf7057ea02e145ccbf6482079c532e4c60ac96727b6068c98f6c4ed3185fc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cabf7057ea02e145ccbf6482079c532e4c60ac96727b6068c98f6c4ed3185fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6566d0cc17c513ca48a323cd2ebdafecfb71ba6bbaddfe2f7de8bbbdd42fcc16"
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