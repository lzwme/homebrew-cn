class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.48/phpstan.phar"
  sha256 "296e2819e8e4aa9d3e929a28222a2a1d78fd0aa00851092bf571599c4d6fb843"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "327d1b8036ece5c9902980ad12984b9182a7a584e0362d27d7af2b0403a56433"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "327d1b8036ece5c9902980ad12984b9182a7a584e0362d27d7af2b0403a56433"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "327d1b8036ece5c9902980ad12984b9182a7a584e0362d27d7af2b0403a56433"
    sha256 cellar: :any_skip_relocation, sonoma:         "a41f41e6dd739d11f97c47ee41002f06d351c590940d4a463fb229741134dc15"
    sha256 cellar: :any_skip_relocation, ventura:        "a41f41e6dd739d11f97c47ee41002f06d351c590940d4a463fb229741134dc15"
    sha256 cellar: :any_skip_relocation, monterey:       "a41f41e6dd739d11f97c47ee41002f06d351c590940d4a463fb229741134dc15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "327d1b8036ece5c9902980ad12984b9182a7a584e0362d27d7af2b0403a56433"
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