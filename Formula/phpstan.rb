class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.23/phpstan.phar"
  sha256 "205af704583ab4490bc48d31ce7aab96441acc2d56799a2dedf081f48d3c7a64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7aa8a56ac525ecb25399e2eef1c7c7c63859ee06076ea029187af3f5834d77f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7aa8a56ac525ecb25399e2eef1c7c7c63859ee06076ea029187af3f5834d77f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7aa8a56ac525ecb25399e2eef1c7c7c63859ee06076ea029187af3f5834d77f"
    sha256 cellar: :any_skip_relocation, ventura:        "6873608517c39a2ef88cb345dbc05e6ff84fc3020ce4d8a1043c3abb28c5d74e"
    sha256 cellar: :any_skip_relocation, monterey:       "6873608517c39a2ef88cb345dbc05e6ff84fc3020ce4d8a1043c3abb28c5d74e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6873608517c39a2ef88cb345dbc05e6ff84fc3020ce4d8a1043c3abb28c5d74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7aa8a56ac525ecb25399e2eef1c7c7c63859ee06076ea029187af3f5834d77f"
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