class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://ghfast.top/https://github.com/vimeo/psalm/releases/download/6.12.1/psalm.phar"
  sha256 "f781a308cd6ac56cb20b2edf61f57e4edc86255b9d539c5ee7bf17f4029edff8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c714bb2081d54732d61f3724e29b246458839e653729fe7770ff753452a5b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c714bb2081d54732d61f3724e29b246458839e653729fe7770ff753452a5b7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c714bb2081d54732d61f3724e29b246458839e653729fe7770ff753452a5b7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f66f78f31d85f2da1a919eeb12cc6fa5f407b2beca27d8e112a4b9be22b92590"
    sha256 cellar: :any_skip_relocation, ventura:       "f66f78f31d85f2da1a919eeb12cc6fa5f407b2beca27d8e112a4b9be22b92590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c714bb2081d54732d61f3724e29b246458839e653729fe7770ff753452a5b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c714bb2081d54732d61f3724e29b246458839e653729fe7770ff753452a5b7f"
  end

  depends_on "composer" => :test
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    libexec.install "psalm.phar" => "psalm"

    (bin/"psalm").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/psalm';
    EOS
  end

  test do
    (testpath/"composer.json").write <<~JSON
      {
        "name": "homebrew/psalm-test",
        "description": "Testing if Psalm has been installed properly.",
        "type": "project",
        "require": {
          "php": ">=8.1"
        },
        "license": "MIT",
        "autoload": {
          "psr-4": {
            "Homebrew\\\\PsalmTest\\\\": "src/"
          }
        },
        "minimum-stability": "stable"
      }
    JSON

    (testpath/"src/Email.php").write <<~PHP
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

        /**
        * @psalm-suppress PossiblyUnusedMethod
        */
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
                 shell_output("#{bin}/psalm --init")
    system bin/"psalm", "--no-progress"
  end
end