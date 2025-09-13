class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghfast.top/https://github.com/phpstan/phpstan/releases/download/2.1.25/phpstan.phar"
  sha256 "77aa32604d0459935922faefcd206322e03dc46b338cfc4be7f50bcfb963dee2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e3e634f8b1a6f3cc866bb2471a52eb080728da1ce163475f539d7a7f7a297d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e3e634f8b1a6f3cc866bb2471a52eb080728da1ce163475f539d7a7f7a297d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbb2eacc069128702493362327b2a9b2e96b644feafcc906f5e5225eddfc7a78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbb2eacc069128702493362327b2a9b2e96b644feafcc906f5e5225eddfc7a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb2eacc069128702493362327b2a9b2e96b644feafcc906f5e5225eddfc7a78"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~PHP
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    PHP

    (testpath/"src/Email.php").write <<~PHP
      <?php
        declare(strict_types=1);

        final class Email
        {
            private string $email;

            private function __construct(string $email)
            {
                $this->ensureIsValidEmail($email);

                $this->email = $email;
            }

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
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    PHP
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end