class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.10.57phpstan.phar"
  sha256 "abea12048448c4ab4cf8b77d71fa36788f3495bb4d3cc201cfb5f2bbc7ff0dc6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60c11232b40f1e6c48951e1036d2cc81161317034e496efa37e9183c07ba5101"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60c11232b40f1e6c48951e1036d2cc81161317034e496efa37e9183c07ba5101"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60c11232b40f1e6c48951e1036d2cc81161317034e496efa37e9183c07ba5101"
    sha256 cellar: :any_skip_relocation, sonoma:         "a101afb5dc121f15861bf9258dc18b5d9b78ad4d07d8df9be63c3f4ee3864b9c"
    sha256 cellar: :any_skip_relocation, ventura:        "a101afb5dc121f15861bf9258dc18b5d9b78ad4d07d8df9be63c3f4ee3864b9c"
    sha256 cellar: :any_skip_relocation, monterey:       "a101afb5dc121f15861bf9258dc18b5d9b78ad4d07d8df9be63c3f4ee3864b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60c11232b40f1e6c48951e1036d2cc81161317034e496efa37e9183c07ba5101"
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