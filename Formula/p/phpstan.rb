class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.11.8phpstan.phar"
  sha256 "6f3ee9f5e95f3bada616436c1733f956ba8975df10eb0035cb21e5cfcd2d82d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52822680a7e0747b7adeb42cb806cee35d9d467de5ce13e7b6b17550d0319bad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52822680a7e0747b7adeb42cb806cee35d9d467de5ce13e7b6b17550d0319bad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52822680a7e0747b7adeb42cb806cee35d9d467de5ce13e7b6b17550d0319bad"
    sha256 cellar: :any_skip_relocation, sonoma:         "75be03ad6c57427526f1019c660a584216b3dfcf9b69533bd0bc61e0b879c4fc"
    sha256 cellar: :any_skip_relocation, ventura:        "75be03ad6c57427526f1019c660a584216b3dfcf9b69533bd0bc61e0b879c4fc"
    sha256 cellar: :any_skip_relocation, monterey:       "75be03ad6c57427526f1019c660a584216b3dfcf9b69533bd0bc61e0b879c4fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41aa5631b3d48c8e10c4b39fb0bfe33bbed93909a2d81bcf92e19829efc5ddfc"
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