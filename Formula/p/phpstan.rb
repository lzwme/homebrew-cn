class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghfast.top/https://github.com/phpstan/phpstan/releases/download/2.1.20/phpstan.phar"
  sha256 "97a97771dcb36a6590988140ad6b4b65f163357ed778597f22c93144edbf5954"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ef69c73283cc5230be016f3afc1e38250aa91bc8d810c06d4930b02f55ab9be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ef69c73283cc5230be016f3afc1e38250aa91bc8d810c06d4930b02f55ab9be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ef69c73283cc5230be016f3afc1e38250aa91bc8d810c06d4930b02f55ab9be"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fdd848905ba188ed6c06919ac372fec0c8296933189c2b449e9d13180dbac88"
    sha256 cellar: :any_skip_relocation, ventura:       "6fdd848905ba188ed6c06919ac372fec0c8296933189c2b449e9d13180dbac88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33a9f2122d679114b70bf53ca3448062040ba8442a90ae3acbbf64e23afb3510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33a9f2122d679114b70bf53ca3448062040ba8442a90ae3acbbf64e23afb3510"
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