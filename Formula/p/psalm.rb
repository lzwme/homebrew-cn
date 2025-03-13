class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.8.9psalm.phar"
  sha256 "bb5ac9ba99d6f7562d45c01923ce59196553de68ebc830ae081e1190a68abc38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6147b482bdd9a60eebbf2247b78bb1c32fc950bc011ede145e9d3e91d6e9f4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6147b482bdd9a60eebbf2247b78bb1c32fc950bc011ede145e9d3e91d6e9f4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6147b482bdd9a60eebbf2247b78bb1c32fc950bc011ede145e9d3e91d6e9f4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "05627ae34be20817196ec11a411ac9136eb03b1569c78caad859049d95162598"
    sha256 cellar: :any_skip_relocation, ventura:       "05627ae34be20817196ec11a411ac9136eb03b1569c78caad859049d95162598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6147b482bdd9a60eebbf2247b78bb1c32fc950bc011ede145e9d3e91d6e9f4c"
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