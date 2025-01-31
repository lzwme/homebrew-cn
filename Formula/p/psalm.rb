class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.1.0psalm.phar"
  sha256 "e73ac5674452344cd9dd15955c4012b5bcc3c901ee7e5d58e8272d3400ae0835"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6be19bbbd97b3d809a5f4e8e772fae8863850feeb9e2f8050d493a9faaa4afb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be19bbbd97b3d809a5f4e8e772fae8863850feeb9e2f8050d493a9faaa4afb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6be19bbbd97b3d809a5f4e8e772fae8863850feeb9e2f8050d493a9faaa4afb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa302e0f7ddd01083dd4c971951335eb9855636cd2c536b724347d7ebf6373da"
    sha256 cellar: :any_skip_relocation, ventura:       "fa302e0f7ddd01083dd4c971951335eb9855636cd2c536b724347d7ebf6373da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6be19bbbd97b3d809a5f4e8e772fae8863850feeb9e2f8050d493a9faaa4afb0"
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