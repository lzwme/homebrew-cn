class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.10.51phpstan.phar"
  sha256 "00b088b0f65a7dc39103ec60a6159e76902a5e457f6f544cf22576532a3657fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ae9a34c5b5c7a16fb47ef3d4bb7dfead8403ca3dcfee1de6cc4114fc881934c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ae9a34c5b5c7a16fb47ef3d4bb7dfead8403ca3dcfee1de6cc4114fc881934c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ae9a34c5b5c7a16fb47ef3d4bb7dfead8403ca3dcfee1de6cc4114fc881934c"
    sha256 cellar: :any_skip_relocation, sonoma:         "851ddcf01ef68f857d140b331002ab10cabcbeeeb72a0c4470d4683c6872032b"
    sha256 cellar: :any_skip_relocation, ventura:        "851ddcf01ef68f857d140b331002ab10cabcbeeeb72a0c4470d4683c6872032b"
    sha256 cellar: :any_skip_relocation, monterey:       "851ddcf01ef68f857d140b331002ab10cabcbeeeb72a0c4470d4683c6872032b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ae9a34c5b5c7a16fb47ef3d4bb7dfead8403ca3dcfee1de6cc4114fc881934c"
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