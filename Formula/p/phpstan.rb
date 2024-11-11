class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.12.9phpstan.phar"
  sha256 "2e7a7a45ce5839c831f6c586f8e265a3be911974bd3fbe59606208b971a92acb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca9609b996fec32073d8023888bfbc307f0a0aadb37a0d9bdd859bd6016a35bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca9609b996fec32073d8023888bfbc307f0a0aadb37a0d9bdd859bd6016a35bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca9609b996fec32073d8023888bfbc307f0a0aadb37a0d9bdd859bd6016a35bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "19e1b6a53dd855328c6fd67a5e47469f4a07515bfadf4d027bed895d76c2fd33"
    sha256 cellar: :any_skip_relocation, ventura:       "19e1b6a53dd855328c6fd67a5e47469f4a07515bfadf4d027bed895d76c2fd33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b3ec5d62d9a582eefb5c92e72e04a2e2a0d98f9f565ecd7203527b9db8c889"
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