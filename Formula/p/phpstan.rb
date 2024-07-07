class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.11.7phpstan.phar"
  sha256 "427d2e5820e736baf667da12e07baef15c356a03b253ba812583d2d9b75af69e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b154ab49ed30e9b9b10d6574c4a641fac664ed7c080168a1613f4e3532d5837"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b154ab49ed30e9b9b10d6574c4a641fac664ed7c080168a1613f4e3532d5837"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b154ab49ed30e9b9b10d6574c4a641fac664ed7c080168a1613f4e3532d5837"
    sha256 cellar: :any_skip_relocation, sonoma:         "265919c429b9c0efd77fe64c3f8f48e5f2bfe4aa435d7f749002d4a09db3c3aa"
    sha256 cellar: :any_skip_relocation, ventura:        "265919c429b9c0efd77fe64c3f8f48e5f2bfe4aa435d7f749002d4a09db3c3aa"
    sha256 cellar: :any_skip_relocation, monterey:       "265919c429b9c0efd77fe64c3f8f48e5f2bfe4aa435d7f749002d4a09db3c3aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e2f9d273fac2b16e90c500520cebd7f258de74ce36d39ab7e4164251b19dec9"
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