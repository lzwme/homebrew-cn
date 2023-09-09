class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://ghproxy.com/https://github.com/sagiegurari/duckscript/archive/0.9.0.tar.gz"
  sha256 "36b6aca7b0d87f348843900165f369721efeec5639e2eeca6c6ab1716db77732"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29cb8c485985ba65050db547fb600453ba3b5681fcc468e23b711a66e1e754bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "358b185ec3d951eb2e57352c39816b618c30a5c3a3d1589c3778e2c807cafded"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ac98e42154d21d571bc698fb24fe451ddc62aabc3842a85507f66d9c97d6384"
    sha256 cellar: :any_skip_relocation, ventura:        "31224b6366dedb3c912e2f0c0da0c492cde99034f64bb014d3fa8492bb3d900d"
    sha256 cellar: :any_skip_relocation, monterey:       "c93f6c08035b9ede67412db605d08ca7060920413a85de7c2a06ac89c25e37ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "d99bc5dff34d7267e438868addaeb3387b4bfe8a2da6a7cbe39c4ec5050df10a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c05a1ca7924aeab3ba174164692e80151f02d1b601f2ad6500cdd96efe88ae0d"
  end

  depends_on "rust" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", "--features", "tls-native", *std_cargo_args(path: "duckscript_cli")
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end