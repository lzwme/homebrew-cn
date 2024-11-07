class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.12.8phpstan.phar"
  sha256 "c83da6a88821803cab2e02bde33283f3759c42980de608dd1a583e0052ee6bab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "034a5df7467371984cd6f7c4f97363efd58a2694bd6dd2027a46a69bdc66f190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "034a5df7467371984cd6f7c4f97363efd58a2694bd6dd2027a46a69bdc66f190"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "034a5df7467371984cd6f7c4f97363efd58a2694bd6dd2027a46a69bdc66f190"
    sha256 cellar: :any_skip_relocation, sonoma:        "4afe0ffd270f2d27d0e83f3cb9461c1987f2ec04fc8f6d790d86292abe75a803"
    sha256 cellar: :any_skip_relocation, ventura:       "4afe0ffd270f2d27d0e83f3cb9461c1987f2ec04fc8f6d790d86292abe75a803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e7777014abfc4d2417adab119e59d6f7b027a29b95ffa8b0d791890ed76ff77"
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