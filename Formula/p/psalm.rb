class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://ghproxy.com/https://github.com/vimeo/psalm/releases/download/5.16.0/psalm.phar"
  sha256 "45350f91f5b537f8bf34212136579a77599fda7eb58f86632859dd3583d9af5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25ae2fd9c7a26ed4eed7e66a67304dfc33fd6bb7cb51b7533f3275aa44c2fd04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25ae2fd9c7a26ed4eed7e66a67304dfc33fd6bb7cb51b7533f3275aa44c2fd04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25ae2fd9c7a26ed4eed7e66a67304dfc33fd6bb7cb51b7533f3275aa44c2fd04"
    sha256 cellar: :any_skip_relocation, sonoma:         "db48069afbb7caab09643932dd347358f22a126c1df46e63a8a6f99bda309952"
    sha256 cellar: :any_skip_relocation, ventura:        "db48069afbb7caab09643932dd347358f22a126c1df46e63a8a6f99bda309952"
    sha256 cellar: :any_skip_relocation, monterey:       "db48069afbb7caab09643932dd347358f22a126c1df46e63a8a6f99bda309952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25ae2fd9c7a26ed4eed7e66a67304dfc33fd6bb7cb51b7533f3275aa44c2fd04"
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
    system bin/"psalm", "--no-progress"
  end
end