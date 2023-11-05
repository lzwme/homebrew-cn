class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://github.com/sharkdp/numbat"
  url "https://ghproxy.com/https://github.com/sharkdp/numbat/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "852502496718892c2de0d3f0b45caef642d07cbcc50a838a0d0b192a5d062354"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b01980ed42c1ff7ef22d3562ab5a2967434595dd25bc3fd52df1d1ef01fb6f79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0eec1645d6303dded809fd8aba5dc7f7582b62a9bdbf178582a70452dc5fc9e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c287f1554226eeceea21863264779c9a7001f1f3a1bc6cfb8ee6b440dd1d885d"
    sha256 cellar: :any_skip_relocation, sonoma:         "642f2e4d65359241f70aef0a480b09a3eb32d31f9481697c37009d8a946a11c7"
    sha256 cellar: :any_skip_relocation, ventura:        "190da677a920b2a2add044c35b677600a684e0d4dbcb96b0b038161076cda98b"
    sha256 cellar: :any_skip_relocation, monterey:       "70eb72c745301ea5c897ab327a463f8ca6d09fd1b2e82336e2e7dfc7df6941e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8ae48622e3e2510e2a86a359f8054de51503223c7b5f2a50e3c85eb6dd598bc"
  end

  depends_on "rust" => :build

  def install
    ENV["NUMBAT_SYSTEM_MODULE_PATH"] = "#{pkgshare}/modules"
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")

    pkgshare.install "numbat/modules"
  end

  test do
    (testpath/"test.nbt").write <<~EOS
      print("pi = {pi}")
    EOS

    output = shell_output("#{bin}/numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end