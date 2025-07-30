class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghfast.top/https://github.com/phpstan/phpstan/releases/download/2.1.21/phpstan.phar"
  sha256 "5575bc0bd0b306567fd890e11fe03c1abb2c0412a01ab21f661c8bf5fb1953f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f859764a178631357b19ea2283f166c0d5f53c7d71a7cf7899c8078110aee402"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f859764a178631357b19ea2283f166c0d5f53c7d71a7cf7899c8078110aee402"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f859764a178631357b19ea2283f166c0d5f53c7d71a7cf7899c8078110aee402"
    sha256 cellar: :any_skip_relocation, sonoma:        "40ee8a88a963bd5e27a78a413a63f7beb1355dc3119101386afe545910495f1d"
    sha256 cellar: :any_skip_relocation, ventura:       "40ee8a88a963bd5e27a78a413a63f7beb1355dc3119101386afe545910495f1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "142ea081e35219de17f45578fd9cf4913870e57f1d7a206a28af348516000228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "142ea081e35219de17f45578fd9cf4913870e57f1d7a206a28af348516000228"
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