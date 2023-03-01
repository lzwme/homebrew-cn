class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://ghproxy.com/https://github.com/jbruchon/jdupes/archive/v1.21.3.tar.gz"
  sha256 "8992d0ff1fe135c685063ce3c9d69d54f1f19f1b32845e84441f888218063cc0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e24324ee039ffdd10282311adb902056e7d77cc253225b2da32da4e98fa869fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8385586fa874ee9821970e3e8673d5075d068d5b6f46fbd5378a9ac9d755895a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b19421ee595a1c69cf7754a1668f017284835b60c917616f1f3b7e86150a66b8"
    sha256 cellar: :any_skip_relocation, ventura:        "7cf8bcafe29ab0bc5bd9ad959e79d9bf6f46077b9236b22b3e03a684944ad265"
    sha256 cellar: :any_skip_relocation, monterey:       "9d78e219df00b25776c1613c92526a1f3c44df4b1bb1fdebe67e65fa7df00279"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d74756fceec7d480e91d3f7d3b38946d3c945b0b7c101f9584ed32cf2b28bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8df5e09093977d45b08da78175dd18e8f221734d34c95cca11be1fec6beca13d"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end