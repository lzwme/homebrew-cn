class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.28/phpstan.phar"
  sha256 "25bb1a99db71ba2d9eb02f56cb12da9162f15a0df79a12892a2fe268457d9db0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e6e8dbcbc5f6c1a3f66ea2b3d824086f0c5e31af8cc0049fdce140adf5fa416"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e6e8dbcbc5f6c1a3f66ea2b3d824086f0c5e31af8cc0049fdce140adf5fa416"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e6e8dbcbc5f6c1a3f66ea2b3d824086f0c5e31af8cc0049fdce140adf5fa416"
    sha256 cellar: :any_skip_relocation, ventura:        "f34755357a25b01167c5e249ab9ef71166c66f8253d7d00e9d21ff57f7d9a978"
    sha256 cellar: :any_skip_relocation, monterey:       "f34755357a25b01167c5e249ab9ef71166c66f8253d7d00e9d21ff57f7d9a978"
    sha256 cellar: :any_skip_relocation, big_sur:        "f34755357a25b01167c5e249ab9ef71166c66f8253d7d00e9d21ff57f7d9a978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e6e8dbcbc5f6c1a3f66ea2b3d824086f0c5e31af8cc0049fdce140adf5fa416"
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