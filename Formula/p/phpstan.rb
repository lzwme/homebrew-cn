class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.1.8phpstan.phar"
  sha256 "278ff54eeac0c586173cb29b69bef81776088d5175cf759c795e7d1747c7c4b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87681553896bf703c944ac6f06cfadbd0deaa75ed9fc89f7d336311157e28ff2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87681553896bf703c944ac6f06cfadbd0deaa75ed9fc89f7d336311157e28ff2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87681553896bf703c944ac6f06cfadbd0deaa75ed9fc89f7d336311157e28ff2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ff917c9ea0d31894daf18ac775c5bf17c988a6ccb7cf7dae42d656dee2cabc9"
    sha256 cellar: :any_skip_relocation, ventura:       "1ff917c9ea0d31894daf18ac775c5bf17c988a6ccb7cf7dae42d656dee2cabc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f2bbfc1f7c260f70c5cf84028b1290b033d61d6ba68dbcce61712562c66fc28"
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