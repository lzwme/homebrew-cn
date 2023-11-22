class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.44/phpstan.phar"
  sha256 "ddb006c2c07d3110c71d23971f2f8b17ba2f2c4307649a635f758f94e25721f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "391d5d964868d19037ab64e71ca0077b580c782cac9af9b8051affba010dcee9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "391d5d964868d19037ab64e71ca0077b580c782cac9af9b8051affba010dcee9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "391d5d964868d19037ab64e71ca0077b580c782cac9af9b8051affba010dcee9"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dd86061c0d2c715644b23b1bfdc6c10b0369e472b6afeb47aa7ef48b17ea1aa"
    sha256 cellar: :any_skip_relocation, ventura:        "3dd86061c0d2c715644b23b1bfdc6c10b0369e472b6afeb47aa7ef48b17ea1aa"
    sha256 cellar: :any_skip_relocation, monterey:       "3dd86061c0d2c715644b23b1bfdc6c10b0369e472b6afeb47aa7ef48b17ea1aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "391d5d964868d19037ab64e71ca0077b580c782cac9af9b8051affba010dcee9"
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
    (testpath/"src/autoload.php").write <<~EOS
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
    EOS

    (testpath/"src/Email.php").write <<~EOS
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
    EOS
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end