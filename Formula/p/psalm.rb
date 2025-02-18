class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.7.1psalm.phar"
  sha256 "05f7c818d54cd37d65828293098dfa1c67260e110332fa9299f060c428c0f6a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ca0e1179f8ded6574c863704ef200f7d232332e54393eeb74b8049b0345d6c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ca0e1179f8ded6574c863704ef200f7d232332e54393eeb74b8049b0345d6c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ca0e1179f8ded6574c863704ef200f7d232332e54393eeb74b8049b0345d6c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "55c6279a57a7827056ea184088a3336c72b527866254f170a9b597167eeb594b"
    sha256 cellar: :any_skip_relocation, ventura:       "55c6279a57a7827056ea184088a3336c72b527866254f170a9b597167eeb594b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ca0e1179f8ded6574c863704ef200f7d232332e54393eeb74b8049b0345d6c6"
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