class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.10/phpstan.phar"
  sha256 "710873008d8e9a0b3fcd9581c03ed1717a9ffc7f6f28a0682d711536b64d8bc3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed3c9dc137fbb6b40a9d4a0ec47bbcf53739123e6d77d52298fa41a4a5b266ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed3c9dc137fbb6b40a9d4a0ec47bbcf53739123e6d77d52298fa41a4a5b266ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed3c9dc137fbb6b40a9d4a0ec47bbcf53739123e6d77d52298fa41a4a5b266ec"
    sha256 cellar: :any_skip_relocation, ventura:        "b3475f53cdc45a7368b5ef325529136ca4626c5dd58b2b0fe91d256367deae01"
    sha256 cellar: :any_skip_relocation, monterey:       "b3475f53cdc45a7368b5ef325529136ca4626c5dd58b2b0fe91d256367deae01"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3475f53cdc45a7368b5ef325529136ca4626c5dd58b2b0fe91d256367deae01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed3c9dc137fbb6b40a9d4a0ec47bbcf53739123e6d77d52298fa41a4a5b266ec"
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