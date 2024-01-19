class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload5.20.0psalm.phar"
  sha256 "ee7924b131d421ffcb703a2fa9cd7212eaea42ad717611e0dd30ecc3da1b5a00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3631ced8c2c2d3de7fc9628f584a507fd45d48ef8f3f5201b4500ec58e25f462"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3631ced8c2c2d3de7fc9628f584a507fd45d48ef8f3f5201b4500ec58e25f462"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3631ced8c2c2d3de7fc9628f584a507fd45d48ef8f3f5201b4500ec58e25f462"
    sha256 cellar: :any_skip_relocation, sonoma:         "64e7dd924028638018da7b0db8829d65c0f45f34542319b5386ae8c68aeede64"
    sha256 cellar: :any_skip_relocation, ventura:        "64e7dd924028638018da7b0db8829d65c0f45f34542319b5386ae8c68aeede64"
    sha256 cellar: :any_skip_relocation, monterey:       "64e7dd924028638018da7b0db8829d65c0f45f34542319b5386ae8c68aeede64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3631ced8c2c2d3de7fc9628f584a507fd45d48ef8f3f5201b4500ec58e25f462"
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