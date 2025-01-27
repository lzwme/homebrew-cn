class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.0.0psalm.phar"
  sha256 "ba24a93743e90c9f41099c87cd1e19817f6cc93dec98e5f7258ca16da554d231"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "435306651b07260a672cf755e3e65c819289d2a2ffd501b31008f67aefb278d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "435306651b07260a672cf755e3e65c819289d2a2ffd501b31008f67aefb278d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "435306651b07260a672cf755e3e65c819289d2a2ffd501b31008f67aefb278d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eb1a3a6210662fdfd0ebdbdebb03d2f9f1ba1ebfdb4b2b36f51c5cdd2408232"
    sha256 cellar: :any_skip_relocation, ventura:       "1eb1a3a6210662fdfd0ebdbdebb03d2f9f1ba1ebfdb4b2b36f51c5cdd2408232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "435306651b07260a672cf755e3e65c819289d2a2ffd501b31008f67aefb278d1"
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