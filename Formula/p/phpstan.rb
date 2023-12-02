class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.47/phpstan.phar"
  sha256 "1414f05643ad3d3156228921048c318cd3184240c237a57004148db70bb11862"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5edb5e588f8efc813efbe6066ea2128882c09ae89d670ed676683d7a45cfa30e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5edb5e588f8efc813efbe6066ea2128882c09ae89d670ed676683d7a45cfa30e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5edb5e588f8efc813efbe6066ea2128882c09ae89d670ed676683d7a45cfa30e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ff3acc2bf372f2dc04e97cb85054cfce83e5c2fa9cd3013731d2ba78d562026"
    sha256 cellar: :any_skip_relocation, ventura:        "4ff3acc2bf372f2dc04e97cb85054cfce83e5c2fa9cd3013731d2ba78d562026"
    sha256 cellar: :any_skip_relocation, monterey:       "4ff3acc2bf372f2dc04e97cb85054cfce83e5c2fa9cd3013731d2ba78d562026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5edb5e588f8efc813efbe6066ea2128882c09ae89d670ed676683d7a45cfa30e"
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
    (testpath/"src/autoload.php").write <<~EOS
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
    EOS

    (testpath/"src/Email.php").write <<~EOS
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
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end