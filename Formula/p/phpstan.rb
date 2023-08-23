class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.30/phpstan.phar"
  sha256 "bfd8a55071a9ca1003410a4ff1d6d4393a78297e3d2ae20158496a0db0c57fa4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf11d8df130d1523a678806e2585d95c32387b5280a075c43dbf5e7e167181e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf11d8df130d1523a678806e2585d95c32387b5280a075c43dbf5e7e167181e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf11d8df130d1523a678806e2585d95c32387b5280a075c43dbf5e7e167181e1"
    sha256 cellar: :any_skip_relocation, ventura:        "784e739ff1eb9fa4d6dee0310dfe3b9b705a6fe899ee64248f03fdd4e76de616"
    sha256 cellar: :any_skip_relocation, monterey:       "784e739ff1eb9fa4d6dee0310dfe3b9b705a6fe899ee64248f03fdd4e76de616"
    sha256 cellar: :any_skip_relocation, big_sur:        "784e739ff1eb9fa4d6dee0310dfe3b9b705a6fe899ee64248f03fdd4e76de616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf11d8df130d1523a678806e2585d95c32387b5280a075c43dbf5e7e167181e1"
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