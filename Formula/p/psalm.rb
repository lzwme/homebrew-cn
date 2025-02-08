class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.5.0psalm.phar"
  sha256 "a18d52fda8d6da26edbb12cefbaf9b689abe4862484687f9a96a7efdecd4ea44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93c842cbe25354286a5e7b44dc89d6e6279f62ba70f1cfa2cbc7d6e688db5ab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93c842cbe25354286a5e7b44dc89d6e6279f62ba70f1cfa2cbc7d6e688db5ab7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93c842cbe25354286a5e7b44dc89d6e6279f62ba70f1cfa2cbc7d6e688db5ab7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5284d76eea8f165b0cd18b6cb3074c45e57d35ad9135961b7d55ca3f5149235c"
    sha256 cellar: :any_skip_relocation, ventura:       "5284d76eea8f165b0cd18b6cb3074c45e57d35ad9135961b7d55ca3f5149235c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93c842cbe25354286a5e7b44dc89d6e6279f62ba70f1cfa2cbc7d6e688db5ab7"
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