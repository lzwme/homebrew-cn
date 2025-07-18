class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghfast.top/https://github.com/phpstan/phpstan/releases/download/2.1.18/phpstan.phar"
  sha256 "d9f6fcf85cfc33c7e5c89090e07615da6eb3b2be351b06522cfa7ff46b166c9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b906a27abdbb429fc5e5f90295a91d120542abceaadbbd83acdc514ac9edf12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b906a27abdbb429fc5e5f90295a91d120542abceaadbbd83acdc514ac9edf12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b906a27abdbb429fc5e5f90295a91d120542abceaadbbd83acdc514ac9edf12"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd75c655b1c6649a49763a1a67505712b60a4401d2bf540f965a3ae2a229c219"
    sha256 cellar: :any_skip_relocation, ventura:       "bd75c655b1c6649a49763a1a67505712b60a4401d2bf540f965a3ae2a229c219"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf5eacd2b6ad205c1369e818b53ffe1ed299f5e0d9842ba72a831a3aa0acaac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf5eacd2b6ad205c1369e818b53ffe1ed299f5e0d9842ba72a831a3aa0acaac9"
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