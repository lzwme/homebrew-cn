class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://ghfast.top/https://github.com/bobthecow/psysh/releases/download/v0.12.19/psysh-v0.12.19.tar.gz"
  sha256 "30e280ec05a6e6a46d960e247afd0bff04a8cd988ed284fcc494fdbeebaf954a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "72b5d2f0e496899672ffac06ff0ab7574e6faf470f6ba1e516ef66d0986601c8"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~PHP
      <?php echo 'hello brew';
    PHP

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end