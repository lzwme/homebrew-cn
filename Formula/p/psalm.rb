class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:psalm.dev"
  url "https:github.comvimeopsalmreleasesdownload6.9.4psalm.phar"
  sha256 "940841e3821416ad20eadee09d765230809b9a69d349758d73dae70085ddc785"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65551035655886a44c8338fdbe91d8e3b4b2395a2a324452858a5316a3ed777d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65551035655886a44c8338fdbe91d8e3b4b2395a2a324452858a5316a3ed777d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65551035655886a44c8338fdbe91d8e3b4b2395a2a324452858a5316a3ed777d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3897afe9dde885b6a98df54f8ef4a548f372be8a5ade5fa09c55252fcd24722"
    sha256 cellar: :any_skip_relocation, ventura:       "e3897afe9dde885b6a98df54f8ef4a548f372be8a5ade5fa09c55252fcd24722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65551035655886a44c8338fdbe91d8e3b4b2395a2a324452858a5316a3ed777d"
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