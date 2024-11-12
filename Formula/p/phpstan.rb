class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.0.1phpstan.phar"
  sha256 "e6c82bd6c839adc29c9575a9a4b0d3efc418d0497c380dac4dd626507d08b87d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f14eedda51695c2b99aed7fde08eaa300d4a7a3d4ca35d20da6979f800688769"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f14eedda51695c2b99aed7fde08eaa300d4a7a3d4ca35d20da6979f800688769"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f14eedda51695c2b99aed7fde08eaa300d4a7a3d4ca35d20da6979f800688769"
    sha256 cellar: :any_skip_relocation, sonoma:        "f098c4d490831dff9aae9960fe0c8a1694cbfe5ce1af2d8935b25399fc2724b0"
    sha256 cellar: :any_skip_relocation, ventura:       "f098c4d490831dff9aae9960fe0c8a1694cbfe5ce1af2d8935b25399fc2724b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16f41a349fb7970fc45ecbc7af9016b22c1aa72c76761b4a7207e2f5648d4fb3"
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