class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://ghproxy.com/https://github.com/vimeo/psalm/releases/download/5.17.0/psalm.phar"
  sha256 "8e8b1bbdbec6ad985f168b63e1a0336c4ef967cfa757f545a72ed59154260943"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d1436dc68bd186e77fd97660ad179631b1ee30ddf66addd6bb54420f100468f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d1436dc68bd186e77fd97660ad179631b1ee30ddf66addd6bb54420f100468f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d1436dc68bd186e77fd97660ad179631b1ee30ddf66addd6bb54420f100468f"
    sha256 cellar: :any_skip_relocation, sonoma:         "218402e9710dac4a94295cfa78f7cf94b22ade14e1192ec7d114025abae0019b"
    sha256 cellar: :any_skip_relocation, ventura:        "218402e9710dac4a94295cfa78f7cf94b22ade14e1192ec7d114025abae0019b"
    sha256 cellar: :any_skip_relocation, monterey:       "218402e9710dac4a94295cfa78f7cf94b22ade14e1192ec7d114025abae0019b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d1436dc68bd186e77fd97660ad179631b1ee30ddf66addd6bb54420f100468f"
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