class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.1.16phpstan.phar"
  sha256 "268a294eb319d572cab5ba93cf0f482384fe936262b6c16750836f3ba4f8b0b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ced2d47ac12fd0807364a6d0d285fa1ab91be469917057d8be6dfd13d4d5a6b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ced2d47ac12fd0807364a6d0d285fa1ab91be469917057d8be6dfd13d4d5a6b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ced2d47ac12fd0807364a6d0d285fa1ab91be469917057d8be6dfd13d4d5a6b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6774522beca5fb34c5daf39a1d6961dfd8f4e135760964edd8196a403c3db68"
    sha256 cellar: :any_skip_relocation, ventura:       "c6774522beca5fb34c5daf39a1d6961dfd8f4e135760964edd8196a403c3db68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92a29be6b1b3e03f8323633118710440eb34b7268094460a1dcca4b27cfeca56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92a29be6b1b3e03f8323633118710440eb34b7268094460a1dcca4b27cfeca56"
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