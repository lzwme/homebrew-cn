class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.12.2phpstan.phar"
  sha256 "4b07c71ffc26e8c95689608d1c7f2d6f3e6a33533afa5b6727222bc016bd6ecb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f10ca734421c7094f297c671e24c6fb907dd2454487c329c22310bca0afcd599"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f10ca734421c7094f297c671e24c6fb907dd2454487c329c22310bca0afcd599"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f10ca734421c7094f297c671e24c6fb907dd2454487c329c22310bca0afcd599"
    sha256 cellar: :any_skip_relocation, sonoma:         "297ca5d29997b20dc0ef1b65633924d65e0f7d547fa0b1a44c7411ef336908d3"
    sha256 cellar: :any_skip_relocation, ventura:        "297ca5d29997b20dc0ef1b65633924d65e0f7d547fa0b1a44c7411ef336908d3"
    sha256 cellar: :any_skip_relocation, monterey:       "297ca5d29997b20dc0ef1b65633924d65e0f7d547fa0b1a44c7411ef336908d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14d539294a21fc96caced80ef90214037417a0b5ef6275f2f7fa43a6288b82dc"
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