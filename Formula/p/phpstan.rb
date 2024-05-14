class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.11.0phpstan.phar"
  sha256 "a4f81e104f5da1e9387cf33a2757f0aafed17a5a3a56b283e6a98a4e9f11349e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08dfae23352f441ddb267b4b8e7731f6fc5e3cbe73e76f8a3da03119d42b8485"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1685c6288cdccb743b669ecc20fdcd051931565ae4b3b2e0028d742334378055"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8914e48ebe6be0570ab58c5fe0fe76f31b8140953f28aad475f5a0e9e893f2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "183ddd35f55fead47bf652081110352fc94490ae32e183e3e95c62d63c001fbd"
    sha256 cellar: :any_skip_relocation, ventura:        "123b7a88bb636a0d71186cda6e0e55075de799e2a154686ff173a671ab8bab20"
    sha256 cellar: :any_skip_relocation, monterey:       "3c2191ef31390b757b6e743fcc253b7e27130e2a3e34fd1db223b1061972cc64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e4e67ff4a83b04ec40d8b886cfac88e0ae4864270872d87e1ffd90503b03962"
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