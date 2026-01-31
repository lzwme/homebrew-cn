class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghfast.top/https://github.com/phpstan/phpstan/releases/download/2.1.38/phpstan.phar"
  sha256 "c5d5df97692a888d2abca6dbcb4db4705add2e4e91cade9f74a2d418261e509d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36f16b688b3e3c2a604b5554f42d3c0e0a01713ed971a1bbce890a82503c3d70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36f16b688b3e3c2a604b5554f42d3c0e0a01713ed971a1bbce890a82503c3d70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36f16b688b3e3c2a604b5554f42d3c0e0a01713ed971a1bbce890a82503c3d70"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfb857364e7e69d2b2ee00f600f7b33c123117e6e42bf489b5af55b2d6dc1ece"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfb857364e7e69d2b2ee00f600f7b33c123117e6e42bf489b5af55b2d6dc1ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfb857364e7e69d2b2ee00f600f7b33c123117e6e42bf489b5af55b2d6dc1ece"
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
    (testpath/"src/autoload.php").write <<~PHP
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
    PHP

    (testpath/"src/Email.php").write <<~PHP
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
    PHP
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end