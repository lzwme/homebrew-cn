class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload5.22.2psalm.phar"
  sha256 "6a0f34f176b5cab8cff8a15fdaa8061ca806758846bbe7b4d81a3d893c844bee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c32b0837385bed3e85ceff3eaa5441499e4aca6dd0690ba01beab7f68626119"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c32b0837385bed3e85ceff3eaa5441499e4aca6dd0690ba01beab7f68626119"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c32b0837385bed3e85ceff3eaa5441499e4aca6dd0690ba01beab7f68626119"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2717ee90247452cd3b6b604e77a3b1fe8fd68a84953b6fb1c0bf640f5863a77"
    sha256 cellar: :any_skip_relocation, ventura:        "f2717ee90247452cd3b6b604e77a3b1fe8fd68a84953b6fb1c0bf640f5863a77"
    sha256 cellar: :any_skip_relocation, monterey:       "f2717ee90247452cd3b6b604e77a3b1fe8fd68a84953b6fb1c0bf640f5863a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c32b0837385bed3e85ceff3eaa5441499e4aca6dd0690ba01beab7f68626119"
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