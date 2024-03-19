class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.10.63phpstan.phar"
  sha256 "7723e5d51b5a9846a14c263b8c497e3ac3f2983e08bfced7b57cb0b885b610cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "422e6b88f71afcc9449b8cbae405892247b6c545b31f5d3ee33bef9264098854"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "422e6b88f71afcc9449b8cbae405892247b6c545b31f5d3ee33bef9264098854"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "422e6b88f71afcc9449b8cbae405892247b6c545b31f5d3ee33bef9264098854"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca5d106eed219fcd87b49b685473ce3896391f89531b18a0d10673144a309cf6"
    sha256 cellar: :any_skip_relocation, ventura:        "ca5d106eed219fcd87b49b685473ce3896391f89531b18a0d10673144a309cf6"
    sha256 cellar: :any_skip_relocation, monterey:       "ca5d106eed219fcd87b49b685473ce3896391f89531b18a0d10673144a309cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "422e6b88f71afcc9449b8cbae405892247b6c545b31f5d3ee33bef9264098854"
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