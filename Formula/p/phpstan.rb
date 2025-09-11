class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghfast.top/https://github.com/phpstan/phpstan/releases/download/2.1.23/phpstan.phar"
  sha256 "3b528ec7afa347bd3c0cf5ac0bbc982ea26099e672d70cd78f237e6fe8bdaae6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "963881142b4450c2b0359bee264e87ab032350da632bbfb3eac8b70e03002bb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "963881142b4450c2b0359bee264e87ab032350da632bbfb3eac8b70e03002bb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "963881142b4450c2b0359bee264e87ab032350da632bbfb3eac8b70e03002bb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecbedac9af91886b47dd4f7e8c1c013a490b8c4dd5992723553dd600adf2f72d"
    sha256 cellar: :any_skip_relocation, ventura:       "ecbedac9af91886b47dd4f7e8c1c013a490b8c4dd5992723553dd600adf2f72d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecbedac9af91886b47dd4f7e8c1c013a490b8c4dd5992723553dd600adf2f72d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecbedac9af91886b47dd4f7e8c1c013a490b8c4dd5992723553dd600adf2f72d"
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