class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghfast.top/https://github.com/phpstan/phpstan/releases/download/2.1.31/phpstan.phar"
  sha256 "f9b7ebabd110dcf628c8f62f7a974b07b54cb0bb62cf9142d8db17dbc6cd39fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae86b1be413275813a6a694ca61d36032778da3ec1c4662d14eb4c4396f8108f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae86b1be413275813a6a694ca61d36032778da3ec1c4662d14eb4c4396f8108f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae86b1be413275813a6a694ca61d36032778da3ec1c4662d14eb4c4396f8108f"
    sha256 cellar: :any_skip_relocation, sonoma:        "93f0ae2ec554200cca0c6c73610f21ac761b3a618c1dede57a4c619606a40042"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93f0ae2ec554200cca0c6c73610f21ac761b3a618c1dede57a4c619606a40042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93f0ae2ec554200cca0c6c73610f21ac761b3a618c1dede57a4c619606a40042"
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