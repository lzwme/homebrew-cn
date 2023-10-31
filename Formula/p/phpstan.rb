class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.40/phpstan.phar"
  sha256 "1dab44701707c35b7ee2ece145b414eca7f158fddc1d28e8d9954d45b55be117"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1a98c951cef2a3cf1f38eb884973652c593bdd996f444eb4d78d115eed4d20d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1a98c951cef2a3cf1f38eb884973652c593bdd996f444eb4d78d115eed4d20d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1a98c951cef2a3cf1f38eb884973652c593bdd996f444eb4d78d115eed4d20d"
    sha256 cellar: :any_skip_relocation, sonoma:         "71e0d78ebd47ada8c878df22413a916354a0a7589de5dfa8ce8e1da6b07f6a9f"
    sha256 cellar: :any_skip_relocation, ventura:        "71e0d78ebd47ada8c878df22413a916354a0a7589de5dfa8ce8e1da6b07f6a9f"
    sha256 cellar: :any_skip_relocation, monterey:       "71e0d78ebd47ada8c878df22413a916354a0a7589de5dfa8ce8e1da6b07f6a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1a98c951cef2a3cf1f38eb884973652c593bdd996f444eb4d78d115eed4d20d"
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