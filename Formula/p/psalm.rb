class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.8.4psalm.phar"
  sha256 "7644dc9212027e7be1163179f303ff0dfc5420362afd8257af3c76d277a79abe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2de630cda634e4da5baf6ccbd3e000a7c5e849f12d357d91880f372258ebeb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2de630cda634e4da5baf6ccbd3e000a7c5e849f12d357d91880f372258ebeb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2de630cda634e4da5baf6ccbd3e000a7c5e849f12d357d91880f372258ebeb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d51ef161c96bb7e71e39699bd06c8f3b91574e66ceb75bda93149fd16a73622e"
    sha256 cellar: :any_skip_relocation, ventura:       "d51ef161c96bb7e71e39699bd06c8f3b91574e66ceb75bda93149fd16a73622e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2de630cda634e4da5baf6ccbd3e000a7c5e849f12d357d91880f372258ebeb1"
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