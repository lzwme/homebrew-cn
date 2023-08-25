class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.32/phpstan.phar"
  sha256 "e71bde77556184a366b3b9e2ce11fe733eefb42ac14e460c011e1fa763e50d09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67b203bf33b375c7970cc14915583ad7f23c3c85e302300a044a0b2f62a66843"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67b203bf33b375c7970cc14915583ad7f23c3c85e302300a044a0b2f62a66843"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67b203bf33b375c7970cc14915583ad7f23c3c85e302300a044a0b2f62a66843"
    sha256 cellar: :any_skip_relocation, ventura:        "eb196a47848db1f56dcfbb865d90c52991fee7692fd87746cd517fc34a3ade72"
    sha256 cellar: :any_skip_relocation, monterey:       "eb196a47848db1f56dcfbb865d90c52991fee7692fd87746cd517fc34a3ade72"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb196a47848db1f56dcfbb865d90c52991fee7692fd87746cd517fc34a3ade72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67b203bf33b375c7970cc14915583ad7f23c3c85e302300a044a0b2f62a66843"
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