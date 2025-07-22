class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghfast.top/https://github.com/phpstan/phpstan/releases/download/2.1.19/phpstan.phar"
  sha256 "82d41ce0169adfdffe522eda2a1cf94fb3450b9839f2a029841c9cf4a556a7d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a8e074839a88c70eca51618a10fe2ad6cee1d0be04cb5f2e8351b241b76bbde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a8e074839a88c70eca51618a10fe2ad6cee1d0be04cb5f2e8351b241b76bbde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a8e074839a88c70eca51618a10fe2ad6cee1d0be04cb5f2e8351b241b76bbde"
    sha256 cellar: :any_skip_relocation, sonoma:        "efe5ceef94036476c46944de0271ef0fcb4b57b649166c14e0149dba78b4a12d"
    sha256 cellar: :any_skip_relocation, ventura:       "efe5ceef94036476c46944de0271ef0fcb4b57b649166c14e0149dba78b4a12d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "053c5afb370098ef104bcb8dd6c0a683b0a7da0a977ad1184f82b51af1740466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "053c5afb370098ef104bcb8dd6c0a683b0a7da0a977ad1184f82b51af1740466"
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