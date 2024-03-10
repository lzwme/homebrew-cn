class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload5.23.0psalm.phar"
  sha256 "9e4a00f58bc40bbbcb64443f33b03a2a40d4add6a472c6712d38cc6a466b9a15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea53e57e8a280900cd6d4d26ae677f2e6d402cd4fc961fe1ad021e5a99b59a8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea53e57e8a280900cd6d4d26ae677f2e6d402cd4fc961fe1ad021e5a99b59a8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea53e57e8a280900cd6d4d26ae677f2e6d402cd4fc961fe1ad021e5a99b59a8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2abe9858c2991baabbc89861ac6750d888249957d1f5ccfd3a7da803363abd1"
    sha256 cellar: :any_skip_relocation, ventura:        "f2abe9858c2991baabbc89861ac6750d888249957d1f5ccfd3a7da803363abd1"
    sha256 cellar: :any_skip_relocation, monterey:       "f2abe9858c2991baabbc89861ac6750d888249957d1f5ccfd3a7da803363abd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea53e57e8a280900cd6d4d26ae677f2e6d402cd4fc961fe1ad021e5a99b59a8c"
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