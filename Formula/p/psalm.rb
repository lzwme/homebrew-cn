class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.6.0psalm.phar"
  sha256 "b1c0d21f48e080693f5085cc3a5c812a1246811aa287527aa0925db7c4b0c406"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43cb8c6819036f693daa0df0e6e4f9b1332e6d12341b38946be356e300b22d4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43cb8c6819036f693daa0df0e6e4f9b1332e6d12341b38946be356e300b22d4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43cb8c6819036f693daa0df0e6e4f9b1332e6d12341b38946be356e300b22d4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5a5768a78d6f98fb12fcb3898a66708ff75a2adfb914b635e81731c04d13dfe"
    sha256 cellar: :any_skip_relocation, ventura:       "c5a5768a78d6f98fb12fcb3898a66708ff75a2adfb914b635e81731c04d13dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43cb8c6819036f693daa0df0e6e4f9b1332e6d12341b38946be356e300b22d4b"
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
    libexec.install "psalm.phar" => "psalm"

    (bin"psalm").write <<~EOS
      #!#{Formula["php"].opt_bin}php
      <?php require '#{libexec}psalm';
    EOS
  end

  test do
    (testpath"composer.json").write <<~JSON
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
    JSON

    (testpath"srcEmail.php").write <<~PHP
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
    PHP

    system "composer", "install"

    assert_match "Config file created successfully. Please re-run psalm.",
                 shell_output("#{bin}psalm --init")
    system bin"psalm", "--no-progress"
  end
end