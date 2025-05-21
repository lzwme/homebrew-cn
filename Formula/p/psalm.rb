class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.11.0psalm.phar"
  sha256 "dc3704e135a7d45fc3ca163874f84bd1572f61cfdbb70736bc01c662c2928946"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f05cdcc12a0d8f798d0180674d9cc8a1c085fa0d4b2d35d2d4a74451328e3ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f05cdcc12a0d8f798d0180674d9cc8a1c085fa0d4b2d35d2d4a74451328e3ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f05cdcc12a0d8f798d0180674d9cc8a1c085fa0d4b2d35d2d4a74451328e3ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "6efaeed249b8109c5b87b4d5636809b23692d3f958f448cebec37bdb2992155b"
    sha256 cellar: :any_skip_relocation, ventura:       "6efaeed249b8109c5b87b4d5636809b23692d3f958f448cebec37bdb2992155b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f05cdcc12a0d8f798d0180674d9cc8a1c085fa0d4b2d35d2d4a74451328e3ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f05cdcc12a0d8f798d0180674d9cc8a1c085fa0d4b2d35d2d4a74451328e3ce"
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