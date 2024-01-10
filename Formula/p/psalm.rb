class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload5.19.0psalm.phar"
  sha256 "5e706af79dd32fc9ae1e3219d5a6365721c4f92c2b176b8e8790696b09f3e4ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c84977722d6ca2bc5b4c20d2dd70927cf5811e66131235e720a9afc9e9b954a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c84977722d6ca2bc5b4c20d2dd70927cf5811e66131235e720a9afc9e9b954a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c84977722d6ca2bc5b4c20d2dd70927cf5811e66131235e720a9afc9e9b954a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c5f2c301d450c007f4a11cb422c091a324b5978749c3d4aea629af6c2c18d60"
    sha256 cellar: :any_skip_relocation, ventura:        "4c5f2c301d450c007f4a11cb422c091a324b5978749c3d4aea629af6c2c18d60"
    sha256 cellar: :any_skip_relocation, monterey:       "4c5f2c301d450c007f4a11cb422c091a324b5978749c3d4aea629af6c2c18d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c84977722d6ca2bc5b4c20d2dd70927cf5811e66131235e720a9afc9e9b954a1"
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