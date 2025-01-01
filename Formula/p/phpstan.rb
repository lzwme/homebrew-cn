class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.1.0phpstan.phar"
  sha256 "a9293d0e8ce2002a0de970e93ae505a0ce18070e52316764b76d84134751cafd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bcb4899aadb210616684db8719e66e7c1cad75a044bfe63e8efff02be91b9ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bcb4899aadb210616684db8719e66e7c1cad75a044bfe63e8efff02be91b9ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bcb4899aadb210616684db8719e66e7c1cad75a044bfe63e8efff02be91b9ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8571f981056ec9175ed0b2bfa977f763cf8a1f73ac0809d81d58287ba03e385"
    sha256 cellar: :any_skip_relocation, ventura:       "f8571f981056ec9175ed0b2bfa977f763cf8a1f73ac0809d81d58287ba03e385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ae2e692a41c6928b8c70ca96ca254db9bca7d281bca35b1c2243e8de71ac57"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `usrlocal` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath"srcautoload.php").write <<~PHP
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => 'Email.php'
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

    (testpath"srcEmail.php").write <<~PHP
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
    assert_match(^\n \[OK\] No errors,
      shell_output("#{bin}phpstan analyse --level max --autoload-file srcautoload.php srcEmail.php"))
  end
end