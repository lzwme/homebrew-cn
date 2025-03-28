class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.9.6psalm.phar"
  sha256 "267a3eeb3b085061a2e82d66b862d44251eabbf393881409897cafa970a082fa"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2af107c1eb7ea9411a616e6a7472091364e2aeaf1a4aae44c8279e261789b2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2af107c1eb7ea9411a616e6a7472091364e2aeaf1a4aae44c8279e261789b2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2af107c1eb7ea9411a616e6a7472091364e2aeaf1a4aae44c8279e261789b2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1d5f694c7132e565417add1d6bdb5062bb72d627a5a0f6130e4ad9e3e4c8011"
    sha256 cellar: :any_skip_relocation, ventura:       "f1d5f694c7132e565417add1d6bdb5062bb72d627a5a0f6130e4ad9e3e4c8011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2af107c1eb7ea9411a616e6a7472091364e2aeaf1a4aae44c8279e261789b2e"
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