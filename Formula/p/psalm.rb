class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://ghproxy.com/https://github.com/vimeo/psalm/releases/download/5.13.1/psalm.phar"
  sha256 "90c34be3831ad00dd1058c4b50697a917bcea6967c14ab761136f665aaac3ac6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7be5c1c55842cee1ac95a18db5dacb421e7b3251519a141989384dce3f5c75c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d07c1f4b179f5e94e02abe2e01bd1312b6359160a836c1142bea57f78b027f48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d07c1f4b179f5e94e02abe2e01bd1312b6359160a836c1142bea57f78b027f48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d07c1f4b179f5e94e02abe2e01bd1312b6359160a836c1142bea57f78b027f48"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce203bbc75d90b452ad1ba279e19f192adf6519178b3428a897d557b89863c41"
    sha256 cellar: :any_skip_relocation, ventura:        "77b36603304bf2336bb0741a915ce6af7fde2724663c9f8b66ed880a30234d78"
    sha256 cellar: :any_skip_relocation, monterey:       "77b36603304bf2336bb0741a915ce6af7fde2724663c9f8b66ed880a30234d78"
    sha256 cellar: :any_skip_relocation, big_sur:        "77b36603304bf2336bb0741a915ce6af7fde2724663c9f8b66ed880a30234d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d07c1f4b179f5e94e02abe2e01bd1312b6359160a836c1142bea57f78b027f48"
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
    bin.install "psalm.phar" => "psalm"
  end

  test do
    (testpath/"composer.json").write <<~EOS
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
    EOS

    (testpath/"src/Email.php").write <<~EOS
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
    EOS

    system "composer", "install"

    assert_match "Config file created successfully. Please re-run psalm.",
                 shell_output("#{bin}/psalm --init")
    assert_match "No errors found!",
                 shell_output("#{bin}/psalm")
  end
end