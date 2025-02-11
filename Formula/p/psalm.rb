class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.5.1psalm.phar"
  sha256 "9b9fa1803088c42823a40a25b5bedd68d670fea7f9c600219581aaba4fa75f22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fc0ac3cf24e37d008834ecc79c5544c2fc30ff89340291254ade3b7f5e5e84c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fc0ac3cf24e37d008834ecc79c5544c2fc30ff89340291254ade3b7f5e5e84c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fc0ac3cf24e37d008834ecc79c5544c2fc30ff89340291254ade3b7f5e5e84c"
    sha256 cellar: :any_skip_relocation, sonoma:        "365046f7649f8082ce0a03df12f371fc729358d625df99c53f89798f4e766216"
    sha256 cellar: :any_skip_relocation, ventura:       "365046f7649f8082ce0a03df12f371fc729358d625df99c53f89798f4e766216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fc0ac3cf24e37d008834ecc79c5544c2fc30ff89340291254ade3b7f5e5e84c"
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