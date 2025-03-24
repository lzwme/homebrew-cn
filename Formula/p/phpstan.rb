class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.1.10phpstan.phar"
  sha256 "d8e5d7aee69e3092ce6d7e36549cf3af0414baf7c5649030c4bee8df59825b4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66fadb339c51a3d9fc43293a9b7ff99721869ec957fa6771114e36ccc9984ad2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66fadb339c51a3d9fc43293a9b7ff99721869ec957fa6771114e36ccc9984ad2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66fadb339c51a3d9fc43293a9b7ff99721869ec957fa6771114e36ccc9984ad2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cc497327a7cef1b1e9c2d4993d553c6e702f0c204e008d01a81e663c92315a6"
    sha256 cellar: :any_skip_relocation, ventura:       "5cc497327a7cef1b1e9c2d4993d553c6e702f0c204e008d01a81e663c92315a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb37ace23689fd45728a2b4e1d95a838014545a32a39be169a292e57491ddca"
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