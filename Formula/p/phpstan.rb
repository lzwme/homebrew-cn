class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.12.4phpstan.phar"
  sha256 "eacf43e8a64625115c8ced094633b079ee72e42bcd8dc19ea2ea9241c244155c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fd9902f56ec41a398a9c425ae00d76ed1e88c28360ad6018443bd4dc735ad24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd9902f56ec41a398a9c425ae00d76ed1e88c28360ad6018443bd4dc735ad24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fd9902f56ec41a398a9c425ae00d76ed1e88c28360ad6018443bd4dc735ad24"
    sha256 cellar: :any_skip_relocation, sonoma:        "e58a3a820bfd9cec779f28eec96c21ce10644b4efdf5807fb92357d989864185"
    sha256 cellar: :any_skip_relocation, ventura:       "e58a3a820bfd9cec779f28eec96c21ce10644b4efdf5807fb92357d989864185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "594c7080e80906f7f0da4dcc618eaaf79d9c5edd92f09c928603412979ee7235"
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