class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.11.5phpstan.phar"
  sha256 "a1c0159b96a54eb498a0463a6bc23549c94708f5b0559c02e6a4cf05d030c7ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0addbd2e3a737cde27a111790d9168075780242cf390f2a044523bcb4410fa26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0addbd2e3a737cde27a111790d9168075780242cf390f2a044523bcb4410fa26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0addbd2e3a737cde27a111790d9168075780242cf390f2a044523bcb4410fa26"
    sha256 cellar: :any_skip_relocation, sonoma:         "5234ecbef861465448c27f7c545022a9ab1eff034dc278eb44137cb6d74e7145"
    sha256 cellar: :any_skip_relocation, ventura:        "5234ecbef861465448c27f7c545022a9ab1eff034dc278eb44137cb6d74e7145"
    sha256 cellar: :any_skip_relocation, monterey:       "5234ecbef861465448c27f7c545022a9ab1eff034dc278eb44137cb6d74e7145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d9ef2c126ad39bdcd43e121aa8bcdcb9ca8d2a8b95bc6438e6a28951059bdc9"
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