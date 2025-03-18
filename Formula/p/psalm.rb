class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.9.0psalm.phar"
  sha256 "6489b23a966ec1319227a6206a2741d51d85c774cafc251acca316097be87d56"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd040d7d65ddc11d59ce635dad2389e5987111481ad48e61f6d6ef515a6355fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd040d7d65ddc11d59ce635dad2389e5987111481ad48e61f6d6ef515a6355fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd040d7d65ddc11d59ce635dad2389e5987111481ad48e61f6d6ef515a6355fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9348376a6a30632f70c02cbeda788516dddfa106274d1bb085f3422b994b52a2"
    sha256 cellar: :any_skip_relocation, ventura:       "9348376a6a30632f70c02cbeda788516dddfa106274d1bb085f3422b994b52a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd040d7d65ddc11d59ce635dad2389e5987111481ad48e61f6d6ef515a6355fd"
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