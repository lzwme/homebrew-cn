class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.20/phpstan.phar"
  sha256 "970ce7e0b719e2ba14ce1ea8a816531fed4039cc6b61fd78d98ae34bcd8111b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54dae72551592051bafdeaa6e0f712762391dc1365471acfd509b2e120318c94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54dae72551592051bafdeaa6e0f712762391dc1365471acfd509b2e120318c94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54dae72551592051bafdeaa6e0f712762391dc1365471acfd509b2e120318c94"
    sha256 cellar: :any_skip_relocation, ventura:        "c4fd4f1eece2c7f19ff0ab33d0a445059c43d7e7744b3ca804b936cc074ed73f"
    sha256 cellar: :any_skip_relocation, monterey:       "c4fd4f1eece2c7f19ff0ab33d0a445059c43d7e7744b3ca804b936cc074ed73f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4fd4f1eece2c7f19ff0ab33d0a445059c43d7e7744b3ca804b936cc074ed73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54dae72551592051bafdeaa6e0f712762391dc1365471acfd509b2e120318c94"
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