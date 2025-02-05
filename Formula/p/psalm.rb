class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.3.0psalm.phar"
  sha256 "0c8471df657a66689ab6b8036c9409ad68ea0d123f5a9c8a4188f1977736dbd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6b8713cc1a28d4e55cf16a1e7f86bc1714688d9395a92e7fb661024330bb283"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6b8713cc1a28d4e55cf16a1e7f86bc1714688d9395a92e7fb661024330bb283"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6b8713cc1a28d4e55cf16a1e7f86bc1714688d9395a92e7fb661024330bb283"
    sha256 cellar: :any_skip_relocation, sonoma:        "212d43981948805cdd97db99b8dc03f7e0e3a7755d858f84312b9e0c4a332347"
    sha256 cellar: :any_skip_relocation, ventura:       "212d43981948805cdd97db99b8dc03f7e0e3a7755d858f84312b9e0c4a332347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6b8713cc1a28d4e55cf16a1e7f86bc1714688d9395a92e7fb661024330bb283"
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