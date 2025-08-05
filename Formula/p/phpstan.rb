class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghfast.top/https://github.com/phpstan/phpstan/releases/download/2.1.22/phpstan.phar"
  sha256 "5343ee639495ce8fff3682c7515c8081641c887cd6087f8c0793f9b5c8e59cc0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4ac1fedaae069c245fd33e5ff90924dfe39a651a064081fa2c1d5a31145e96f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4ac1fedaae069c245fd33e5ff90924dfe39a651a064081fa2c1d5a31145e96f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4ac1fedaae069c245fd33e5ff90924dfe39a651a064081fa2c1d5a31145e96f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ff4dc7493ece4e71b42fcb975c2d6e5f851470bf64b3938c2360fd8ec82422d"
    sha256 cellar: :any_skip_relocation, ventura:       "4ff4dc7493ece4e71b42fcb975c2d6e5f851470bf64b3938c2360fd8ec82422d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d17aca678dd64724dcc55fca8c08e56c1e25f4d0addc5cdd4561ac4aeb7864b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d17aca678dd64724dcc55fca8c08e56c1e25f4d0addc5cdd4561ac4aeb7864b8"
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