class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.12.1phpstan.phar"
  sha256 "8ed63289b7f58f4d0b704e39acf4dedd1c18f48634cf7696093279ba794bcd8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6502bd3cd063ff15b50206b00e044d1a48300be95e571ad83ff94aad88d301d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6502bd3cd063ff15b50206b00e044d1a48300be95e571ad83ff94aad88d301d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6502bd3cd063ff15b50206b00e044d1a48300be95e571ad83ff94aad88d301d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b183938eecef97dc23e688358f56390ad42c07a924e94e796fa9c08a7d55516c"
    sha256 cellar: :any_skip_relocation, ventura:        "b183938eecef97dc23e688358f56390ad42c07a924e94e796fa9c08a7d55516c"
    sha256 cellar: :any_skip_relocation, monterey:       "b183938eecef97dc23e688358f56390ad42c07a924e94e796fa9c08a7d55516c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e50b083fe1b4ffe8e0d5b383a81ee1af563391f00fc9355f4195d80cc0f88f66"
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
    (testpath"srcautoload.php").write <<~EOS
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
    EOS

    (testpath"srcEmail.php").write <<~EOS
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
    assert_match(^\n \[OK\] No errors,
      shell_output("#{bin}phpstan analyse --level max --autoload-file srcautoload.php srcEmail.php"))
  end
end