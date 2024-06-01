class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.11.3phpstan.phar"
  sha256 "3c469ef2ddc973be2864fdf5ea12d4157a636f7a39ac4355dc92e347d08ef15c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f55ace3fbcacbb68eed271e47e99f5461292e41b87d7f46bf658eaf3d2e376e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f55ace3fbcacbb68eed271e47e99f5461292e41b87d7f46bf658eaf3d2e376e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f55ace3fbcacbb68eed271e47e99f5461292e41b87d7f46bf658eaf3d2e376e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c69203eecc53f74a332eaeef8ae91d63643839b0a51b097331211429004ba758"
    sha256 cellar: :any_skip_relocation, ventura:        "c69203eecc53f74a332eaeef8ae91d63643839b0a51b097331211429004ba758"
    sha256 cellar: :any_skip_relocation, monterey:       "c69203eecc53f74a332eaeef8ae91d63643839b0a51b097331211429004ba758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daabdfd5a317b784106248359c26c4150b4ffb66b1183f695683323b8cfd2b54"
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