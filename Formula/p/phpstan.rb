class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.1.12phpstan.phar"
  sha256 "121205dfa1c404a55605b6508af1a0535dd88c8d8fc251f84e8d02f6ffb9c0bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "095482e1aaf5af9bd8ebcb440b343b8efb8ac14883bb61f425df39174a499179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "095482e1aaf5af9bd8ebcb440b343b8efb8ac14883bb61f425df39174a499179"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "095482e1aaf5af9bd8ebcb440b343b8efb8ac14883bb61f425df39174a499179"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a55633b472a672badde28049302743578ab5a98f98b781682f2d7844850bb06"
    sha256 cellar: :any_skip_relocation, ventura:       "2a55633b472a672badde28049302743578ab5a98f98b781682f2d7844850bb06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeee5c8fd8f1e737aba47a984355c057770fbd0a4bb0ed2994bdf3b86c1b56ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeee5c8fd8f1e737aba47a984355c057770fbd0a4bb0ed2994bdf3b86c1b56ce"
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