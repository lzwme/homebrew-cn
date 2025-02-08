class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.1.3phpstan.phar"
  sha256 "17f611f5376596d97d03b7308fe76b3067e203ea5d8fb5fcecb029c88d1c500d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f070b75e2715a84856850658f42fff5c61e2014d45733ac1f738bdb07ca4a6d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f070b75e2715a84856850658f42fff5c61e2014d45733ac1f738bdb07ca4a6d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f070b75e2715a84856850658f42fff5c61e2014d45733ac1f738bdb07ca4a6d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1d10689bb8bc162285a4a50ac7a35ad4905b110a3a1200a2ef2b452541a7638"
    sha256 cellar: :any_skip_relocation, ventura:       "a1d10689bb8bc162285a4a50ac7a35ad4905b110a3a1200a2ef2b452541a7638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "701254c7a9882db7fda6c91ac2515e999e2b97a8af48d1b898fc9f72cc2ae029"
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