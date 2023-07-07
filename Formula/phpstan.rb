class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.25/phpstan.phar"
  sha256 "c3bc0e6651ca38fc7d3e697f711e10df212fb3d2732529e111082152dadb7168"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61cb9c0e949ce22fe4fd0e050ddd38fbbddf12e087ac5367db710f566f3bc3b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61cb9c0e949ce22fe4fd0e050ddd38fbbddf12e087ac5367db710f566f3bc3b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61cb9c0e949ce22fe4fd0e050ddd38fbbddf12e087ac5367db710f566f3bc3b6"
    sha256 cellar: :any_skip_relocation, ventura:        "7567f7174361fb6cf874e20f469a98ff6af44314368133de3ff042fad766fe5f"
    sha256 cellar: :any_skip_relocation, monterey:       "7567f7174361fb6cf874e20f469a98ff6af44314368133de3ff042fad766fe5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7567f7174361fb6cf874e20f469a98ff6af44314368133de3ff042fad766fe5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61cb9c0e949ce22fe4fd0e050ddd38fbbddf12e087ac5367db710f566f3bc3b6"
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