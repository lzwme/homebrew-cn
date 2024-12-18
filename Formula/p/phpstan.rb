class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.0.4phpstan.phar"
  sha256 "9698ada6c50f4add2a240123917ab6525d111f28b44ff003275f8e0fda4d0724"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81d128a15a0dc3f6188524412159f0b2e71a9ed6f9bd62d27340c913470f920c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81d128a15a0dc3f6188524412159f0b2e71a9ed6f9bd62d27340c913470f920c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81d128a15a0dc3f6188524412159f0b2e71a9ed6f9bd62d27340c913470f920c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2efbb8f824d71654edbeee67ad9a3d22b7cac77f25f56f15e57861fc68fb9488"
    sha256 cellar: :any_skip_relocation, ventura:       "2efbb8f824d71654edbeee67ad9a3d22b7cac77f25f56f15e57861fc68fb9488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f6dedbc3fa58cbfa7147bd4c79ee0b68b7a25dd27d3335159122b106eade795"
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