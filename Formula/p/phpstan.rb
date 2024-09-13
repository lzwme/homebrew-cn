class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.12.3phpstan.phar"
  sha256 "c4a653171f9b9a219a7f2787c55b3b4dff59fb3cae7e65db5eb5d2ee8cca515a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fbccc37038811afcb694f3573ab9a6eb7d9e8957e9f90caf7bac6f42e3c10708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbccc37038811afcb694f3573ab9a6eb7d9e8957e9f90caf7bac6f42e3c10708"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbccc37038811afcb694f3573ab9a6eb7d9e8957e9f90caf7bac6f42e3c10708"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbccc37038811afcb694f3573ab9a6eb7d9e8957e9f90caf7bac6f42e3c10708"
    sha256 cellar: :any_skip_relocation, sonoma:         "05377e3e7bb1bce1a5134e43c576804e5234e2817d32b92c3af42a9338ae2cf2"
    sha256 cellar: :any_skip_relocation, ventura:        "05377e3e7bb1bce1a5134e43c576804e5234e2817d32b92c3af42a9338ae2cf2"
    sha256 cellar: :any_skip_relocation, monterey:       "05377e3e7bb1bce1a5134e43c576804e5234e2817d32b92c3af42a9338ae2cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e570f39bb8160acd2a83078b734947d7806f1c53812eaf848f063712bd87ae50"
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