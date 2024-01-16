class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.10.56phpstan.phar"
  sha256 "0e1a75320b855621f2707fdf873f935b309d6d251696232bcdfc40a46f1a4f59"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c95db93549936d9d122f622d35858e0ef341fbb03b549934064ae19423bef2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c95db93549936d9d122f622d35858e0ef341fbb03b549934064ae19423bef2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c95db93549936d9d122f622d35858e0ef341fbb03b549934064ae19423bef2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "784e650ef65f6ef22e8e2c6f72eb3c9a98a71fe62586660591449d470018479e"
    sha256 cellar: :any_skip_relocation, ventura:        "784e650ef65f6ef22e8e2c6f72eb3c9a98a71fe62586660591449d470018479e"
    sha256 cellar: :any_skip_relocation, monterey:       "784e650ef65f6ef22e8e2c6f72eb3c9a98a71fe62586660591449d470018479e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c95db93549936d9d122f622d35858e0ef341fbb03b549934064ae19423bef2f"
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