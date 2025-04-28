class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload2.1.13phpstan.phar"
  sha256 "849285be4c2592b81e1995d7f20f207d71332d9b8c1456cd668fbcdaee0af01d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e156a6540c77b4ec49deaad69dbd5d652284dd563ac28d5a3749241309718a20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e156a6540c77b4ec49deaad69dbd5d652284dd563ac28d5a3749241309718a20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e156a6540c77b4ec49deaad69dbd5d652284dd563ac28d5a3749241309718a20"
    sha256 cellar: :any_skip_relocation, sonoma:        "a55e3bf0faa270e9f436f0fbf9da320657903ccd4653d16d63b554d067032291"
    sha256 cellar: :any_skip_relocation, ventura:       "a55e3bf0faa270e9f436f0fbf9da320657903ccd4653d16d63b554d067032291"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ad25c79c2ed7e12f73c183e87c8c337ef350b7b7eb948cddcb5dc7a93130fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ad25c79c2ed7e12f73c183e87c8c337ef350b7b7eb948cddcb5dc7a93130fc4"
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