class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.24/phpstan.phar"
  sha256 "78686f6682873d131ed7e97de49f3cde2c28e78e0082ddb568c4e35d246f4007"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02f21d67fce7a658298d87d694ce26715c1b0c82795b97d6fd886f9a2ca07102"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02f21d67fce7a658298d87d694ce26715c1b0c82795b97d6fd886f9a2ca07102"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02f21d67fce7a658298d87d694ce26715c1b0c82795b97d6fd886f9a2ca07102"
    sha256 cellar: :any_skip_relocation, ventura:        "4d14627e307ed85977cbe7a1a17f1537f34fb11753262bc970f3f70b36df085b"
    sha256 cellar: :any_skip_relocation, monterey:       "4d14627e307ed85977cbe7a1a17f1537f34fb11753262bc970f3f70b36df085b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d14627e307ed85977cbe7a1a17f1537f34fb11753262bc970f3f70b36df085b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02f21d67fce7a658298d87d694ce26715c1b0c82795b97d6fd886f9a2ca07102"
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