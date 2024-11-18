class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.0.2phpstan.phar"
  sha256 "f2cb0ffc484058486cc5bd585805a1fb21ab5540a79f482c3677f10fe090b3b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406612d6959c99acfb25d6794c1ee36cca389a0a67ecdbd54d92200de0ef063b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "406612d6959c99acfb25d6794c1ee36cca389a0a67ecdbd54d92200de0ef063b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "406612d6959c99acfb25d6794c1ee36cca389a0a67ecdbd54d92200de0ef063b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fe8e7e8cd336a45984a3133882278b948983f1bca15d6aad5dd40b668eeba71"
    sha256 cellar: :any_skip_relocation, ventura:       "3fe8e7e8cd336a45984a3133882278b948983f1bca15d6aad5dd40b668eeba71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33503966cf7b5fde80713ff857ddf59ddb2d03b7778e7e841067f441451fb937"
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