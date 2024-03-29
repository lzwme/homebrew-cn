class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.10.66phpstan.phar"
  sha256 "f93aba668e2ed181afc01f16fad332e601f5d99c87f31cff85f74bd08000f574"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "501af4fb8d8bb7861ef4cb6d6677a9d85d153c75db5cd6d0de9bdf3e1c380c34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "501af4fb8d8bb7861ef4cb6d6677a9d85d153c75db5cd6d0de9bdf3e1c380c34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "501af4fb8d8bb7861ef4cb6d6677a9d85d153c75db5cd6d0de9bdf3e1c380c34"
    sha256 cellar: :any_skip_relocation, sonoma:         "434a862f768de452e0efae5ad954f1fc2edb300f971bd4f737ab4609a5f1a293"
    sha256 cellar: :any_skip_relocation, ventura:        "434a862f768de452e0efae5ad954f1fc2edb300f971bd4f737ab4609a5f1a293"
    sha256 cellar: :any_skip_relocation, monterey:       "434a862f768de452e0efae5ad954f1fc2edb300f971bd4f737ab4609a5f1a293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "501af4fb8d8bb7861ef4cb6d6677a9d85d153c75db5cd6d0de9bdf3e1c380c34"
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