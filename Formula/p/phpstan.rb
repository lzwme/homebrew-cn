class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.12.5phpstan.phar"
  sha256 "5355777ebbf58f691e980e97d2f69eb5ee0b9225b9163f16ee8bc4e7a62e7cf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c9f886fdda73b35d661d1ea91440833aa8f84826fa4d6da213914b4b95c57aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c9f886fdda73b35d661d1ea91440833aa8f84826fa4d6da213914b4b95c57aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c9f886fdda73b35d661d1ea91440833aa8f84826fa4d6da213914b4b95c57aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "3af03bd1e87ce83abca92d08eae491b8c64080a03b046d828ec6dbcd2551dbcf"
    sha256 cellar: :any_skip_relocation, ventura:       "3af03bd1e87ce83abca92d08eae491b8c64080a03b046d828ec6dbcd2551dbcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c7e967456c04325dcbe902026278646de87c202cf40ae6d5dd5554556d6ad21"
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