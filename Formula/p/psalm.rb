class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload5.19.1psalm.phar"
  sha256 "4dc03f403415f9a961e6f6a888b050fa74d0a5073c5aa97ea54aed989fdb756e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4b56810b19c95a75de1b7fe71339ddd11ea220e5b68ab71647891142cd34564"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4b56810b19c95a75de1b7fe71339ddd11ea220e5b68ab71647891142cd34564"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4b56810b19c95a75de1b7fe71339ddd11ea220e5b68ab71647891142cd34564"
    sha256 cellar: :any_skip_relocation, sonoma:         "996a6fa33e80aa54e76dda0fc4440498c57f0a0332759f4c26a5fb1e6341b448"
    sha256 cellar: :any_skip_relocation, ventura:        "996a6fa33e80aa54e76dda0fc4440498c57f0a0332759f4c26a5fb1e6341b448"
    sha256 cellar: :any_skip_relocation, monterey:       "996a6fa33e80aa54e76dda0fc4440498c57f0a0332759f4c26a5fb1e6341b448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4b56810b19c95a75de1b7fe71339ddd11ea220e5b68ab71647891142cd34564"
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
    bin.install "psalm.phar" => "psalm"
  end

  test do
    (testpath"composer.json").write <<~EOS
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
    EOS

    (testpath"srcEmail.php").write <<~EOS
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
    EOS

    system "composer", "install"

    assert_match "Config file created successfully. Please re-run psalm.",
                 shell_output("#{bin}psalm --init")
    system bin"psalm", "--no-progress"
  end
end