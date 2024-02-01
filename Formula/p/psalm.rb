class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload5.21.0psalm.phar"
  sha256 "7d80c64c3513b60986ec1bd967c3f453e0da0fe2c8a4ec853e7608db53d88ed0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "665c0895e3eacb7e564899c76a517f02bd8bd5c169e875a313cdd0a060dbb188"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "665c0895e3eacb7e564899c76a517f02bd8bd5c169e875a313cdd0a060dbb188"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "665c0895e3eacb7e564899c76a517f02bd8bd5c169e875a313cdd0a060dbb188"
    sha256 cellar: :any_skip_relocation, sonoma:         "fde37b7cfc4c6d2191ed3f4654e03cfb492b52ca98df8bfb21693066f09a7b55"
    sha256 cellar: :any_skip_relocation, ventura:        "fde37b7cfc4c6d2191ed3f4654e03cfb492b52ca98df8bfb21693066f09a7b55"
    sha256 cellar: :any_skip_relocation, monterey:       "fde37b7cfc4c6d2191ed3f4654e03cfb492b52ca98df8bfb21693066f09a7b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "665c0895e3eacb7e564899c76a517f02bd8bd5c169e875a313cdd0a060dbb188"
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