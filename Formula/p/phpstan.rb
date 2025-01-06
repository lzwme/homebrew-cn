class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.1.1phpstan.phar"
  sha256 "bb6ed6ff469ea391e3575c11dcd2f39fc55ad033da4032bc4ddb98c08c1c3fd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb5503742637c4802387f06d2a3e8c56b83716187a254911d05b5f299241fc1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb5503742637c4802387f06d2a3e8c56b83716187a254911d05b5f299241fc1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb5503742637c4802387f06d2a3e8c56b83716187a254911d05b5f299241fc1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "28a80054aecce88d4d125f834c73fdbd50e3bfdc1d4229c7cccdda34fdf9ca2a"
    sha256 cellar: :any_skip_relocation, ventura:       "28a80054aecce88d4d125f834c73fdbd50e3bfdc1d4229c7cccdda34fdf9ca2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b218fa05af8aea7fd540d71d1fb35a781a5f0049ea45df375c5f7685d66bf540"
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