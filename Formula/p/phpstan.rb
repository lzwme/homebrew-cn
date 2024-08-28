class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.12.0phpstan.phar"
  sha256 "c7b2bf04ad75cf37792681ca401aa7b2c7bf33e716e986bdfee86da324337f7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3ebc0d9aa38dd12d1085353ade83a89a1bdb415c7512818591757de782d377f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3ebc0d9aa38dd12d1085353ade83a89a1bdb415c7512818591757de782d377f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3ebc0d9aa38dd12d1085353ade83a89a1bdb415c7512818591757de782d377f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b45e0b6a240f94e2078a5d5cfbb18ae310ecf5c83313068f198f3115284e181f"
    sha256 cellar: :any_skip_relocation, ventura:        "b45e0b6a240f94e2078a5d5cfbb18ae310ecf5c83313068f198f3115284e181f"
    sha256 cellar: :any_skip_relocation, monterey:       "b45e0b6a240f94e2078a5d5cfbb18ae310ecf5c83313068f198f3115284e181f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ccd3de8d8e84cb8518fb80a084d37ec2fb47e8fc5a4cbaceafe4e0112871d09"
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