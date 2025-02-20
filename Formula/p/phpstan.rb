class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.1.6phpstan.phar"
  sha256 "a1e55880aca9f53d1db2c89972b74ec8f5ad60cad985b36c271f114a5d2fad0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f45c3eaeeceaca104e6002adf4a76e5eb37c035b203f453ff8525d2c4b68744"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f45c3eaeeceaca104e6002adf4a76e5eb37c035b203f453ff8525d2c4b68744"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f45c3eaeeceaca104e6002adf4a76e5eb37c035b203f453ff8525d2c4b68744"
    sha256 cellar: :any_skip_relocation, sonoma:        "caa51bbc3aa9e5476330ce9201ad51541543a13fb18bee5bc7808b36178984be"
    sha256 cellar: :any_skip_relocation, ventura:       "caa51bbc3aa9e5476330ce9201ad51541543a13fb18bee5bc7808b36178984be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c2192f6019ff7af4cfb4c71f9c785fcee530da1caeb838dbc37b68872c66ac4"
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