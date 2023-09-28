class Phpmd < Formula
  desc "PHP Mess Detector"
  homepage "https://phpmd.org"
  url "https://ghproxy.com/https://github.com/phpmd/phpmd/releases/download/2.14.0/phpmd.phar"
  sha256 "60b9cfab6547fc63359418e82df06e2ab029dc5baa5108958a88ce6c9e89f222"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3005d1ceba0ef2812bf73f159e432a9571f9facf305bc3e6552281c52ac40de7"
  end

  depends_on "php"

  def install
    bin.install "phpmd.phar" => "phpmd"
  end

  test do
    (testpath/"src/HelloWorld/Greetings.php").write <<~EOS
      <?php
      namespace HelloWorld;
      class Greetings {
        public static function sayHelloWorld($name) {
          return 'HelloHomebrew';
        }
      }
    EOS

    assert_match "Avoid unused parameters such as '$name'.",
      shell_output("#{bin}/phpmd --ignore-violations-on-exit src/HelloWorld/Greetings.php text unusedcode")
  end
end