class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload5.21.1psalm.phar"
  sha256 "4452c2c8b1e6e13e0aa7a46b21df2c233b0113bd9ca7d23d1f4c4e72b54194f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6644314e5b9f81a266ad948c7e1a4b788b41a87d2276c84d74237b1bb79f7aab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6644314e5b9f81a266ad948c7e1a4b788b41a87d2276c84d74237b1bb79f7aab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6644314e5b9f81a266ad948c7e1a4b788b41a87d2276c84d74237b1bb79f7aab"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1ff430e72c4880b0ea7ee1b6cd62e4747898eb3f09305a06e1dabf4d3661cb0"
    sha256 cellar: :any_skip_relocation, ventura:        "f1ff430e72c4880b0ea7ee1b6cd62e4747898eb3f09305a06e1dabf4d3661cb0"
    sha256 cellar: :any_skip_relocation, monterey:       "f1ff430e72c4880b0ea7ee1b6cd62e4747898eb3f09305a06e1dabf4d3661cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6644314e5b9f81a266ad948c7e1a4b788b41a87d2276c84d74237b1bb79f7aab"
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
    bin.install "psalm.phar" => "psalm"
  end

  test do
    (testpath"composer.json").write <<~EOS
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
    EOS

    (testpath"srcEmail.php").write <<~EOS
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
    EOS

    system "composer", "install"

    assert_match "Config file created successfully. Please re-run psalm.",
                 shell_output("#{bin}psalm --init")
    system bin"psalm", "--no-progress"
  end
end