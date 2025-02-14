class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.1.5phpstan.phar"
  sha256 "18c5395e801ca3fbb4dadeb5c8fe3461ac8e6e32841dc4b1d7e789d6bca7fd75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "030517b138a6ecb6c97dc2d55141d9ff76274e17ef29303572fb6188b79cc8ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "030517b138a6ecb6c97dc2d55141d9ff76274e17ef29303572fb6188b79cc8ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "030517b138a6ecb6c97dc2d55141d9ff76274e17ef29303572fb6188b79cc8ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf2c048f3807e633acda1aaf7b039a9e3065c77211f7f54289b13a615c01d256"
    sha256 cellar: :any_skip_relocation, ventura:       "bf2c048f3807e633acda1aaf7b039a9e3065c77211f7f54289b13a615c01d256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e9313bb0deae925944756fe240ca3bfbdafa6cad3b68b4018f40b55ec2a3071"
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