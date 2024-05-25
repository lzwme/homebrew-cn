class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.11.2phpstan.phar"
  sha256 "83af0021e1eb3b909fd651a9fbe976888338a820e3f708c2dde5b17031fc739a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35d424123b7c8e5b063180694c907d84dff5feb7a07c8700d67f96d301620f9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35d424123b7c8e5b063180694c907d84dff5feb7a07c8700d67f96d301620f9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35d424123b7c8e5b063180694c907d84dff5feb7a07c8700d67f96d301620f9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab205315e7c1ca760a37e48aa72437221886d9ab3d84ae006741e350be56508b"
    sha256 cellar: :any_skip_relocation, ventura:        "ab205315e7c1ca760a37e48aa72437221886d9ab3d84ae006741e350be56508b"
    sha256 cellar: :any_skip_relocation, monterey:       "f12efe0c7384b1841e8017931ef3f56bcd4d34cfadf019243f90e55f4fcc3aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35d424123b7c8e5b063180694c907d84dff5feb7a07c8700d67f96d301620f9e"
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