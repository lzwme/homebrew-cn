class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://ghproxy.com/https://github.com/bobthecow/psysh/releases/download/v0.11.16/psysh-v0.11.16.tar.gz"
  sha256 "e0512332da7b3114e3a5d6f56692aa09ad1eaf1ad6f742721b2d5998c0557591"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "350e086f0d7884a36abc853528280626253e7ecf71204f8669963011cfd88d19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "350e086f0d7884a36abc853528280626253e7ecf71204f8669963011cfd88d19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "350e086f0d7884a36abc853528280626253e7ecf71204f8669963011cfd88d19"
    sha256 cellar: :any_skip_relocation, ventura:        "abc63227a26f6911a22aaa6677a504750e0370046dea830e0760de2500de9116"
    sha256 cellar: :any_skip_relocation, monterey:       "abc63227a26f6911a22aaa6677a504750e0370046dea830e0760de2500de9116"
    sha256 cellar: :any_skip_relocation, big_sur:        "abc63227a26f6911a22aaa6677a504750e0370046dea830e0760de2500de9116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "350e086f0d7884a36abc853528280626253e7ecf71204f8669963011cfd88d19"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~EOS
      <?php echo 'hello brew';
    EOS

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end