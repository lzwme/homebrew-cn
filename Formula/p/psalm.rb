class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload5.26.0psalm.phar"
  sha256 "417fe51e5f2de75d97a9a13bdcb5f197132368e0f71ec91f911717f8b6697804"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19803eff110a29c63f5bfa63ae0b6c49183645340513f6d4eadceeb3ccdda962"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19803eff110a29c63f5bfa63ae0b6c49183645340513f6d4eadceeb3ccdda962"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19803eff110a29c63f5bfa63ae0b6c49183645340513f6d4eadceeb3ccdda962"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee53d7c612dcca3b4ea95608b2ad43b728af12d3fc4bdd300c205d98cfefdfcc"
    sha256 cellar: :any_skip_relocation, ventura:        "ee53d7c612dcca3b4ea95608b2ad43b728af12d3fc4bdd300c205d98cfefdfcc"
    sha256 cellar: :any_skip_relocation, monterey:       "ee53d7c612dcca3b4ea95608b2ad43b728af12d3fc4bdd300c205d98cfefdfcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19803eff110a29c63f5bfa63ae0b6c49183645340513f6d4eadceeb3ccdda962"
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