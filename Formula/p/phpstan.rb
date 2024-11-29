class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.0.3phpstan.phar"
  sha256 "6192e1d39e18e0a29aac7592a67c65395541ab24f33bf7e09df2f0ad1103d6a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50abdef6096a048f76fc2f0d9f5157d1481318d523989d7e1697770353c90bfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50abdef6096a048f76fc2f0d9f5157d1481318d523989d7e1697770353c90bfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50abdef6096a048f76fc2f0d9f5157d1481318d523989d7e1697770353c90bfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "28a2869466c8b375dff5522ad201926aa21cc68d08e880ef542565aa4fdd4cfa"
    sha256 cellar: :any_skip_relocation, ventura:       "28a2869466c8b375dff5522ad201926aa21cc68d08e880ef542565aa4fdd4cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a87632714c95112133c5a232b4b9df4bfe7e26c1b51c07ce6c81d6078fc53fa"
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