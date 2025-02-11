class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.1.4phpstan.phar"
  sha256 "2bdf163b513e79fa1ae26e97c90511fc09de1bf46d77e9f20d3f316a5e7ffc4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "777a0b701a32e9a1e426a9429c500f23b393f78d601689f2345b2bfb4131b2de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "777a0b701a32e9a1e426a9429c500f23b393f78d601689f2345b2bfb4131b2de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "777a0b701a32e9a1e426a9429c500f23b393f78d601689f2345b2bfb4131b2de"
    sha256 cellar: :any_skip_relocation, sonoma:        "c422620ae15994a0815a3fc266431d2268e6958c9f675755386dd28e963f8462"
    sha256 cellar: :any_skip_relocation, ventura:       "c422620ae15994a0815a3fc266431d2268e6958c9f675755386dd28e963f8462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "234a14cc64c3075d023624296ac53709a618d4ae4ef5a2203c36acf44cfc9c25"
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