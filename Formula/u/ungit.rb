class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https:github.comFredrikNorenungit"
  url "https:registry.npmjs.orgungit-ungit-1.5.27.tgz"
  sha256 "daea92ea66ac52f8359c9964f68779dea7ba1583621bf87473e719395992364c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "599562a33e44c9ebb1f7633a03fa3311a85591b1253d95a2143ee70495b046a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c22aea3141d38c78f0f4cebf19854018dd9caae6716ccbbc82cdc2f39610d8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c22aea3141d38c78f0f4cebf19854018dd9caae6716ccbbc82cdc2f39610d8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c22aea3141d38c78f0f4cebf19854018dd9caae6716ccbbc82cdc2f39610d8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd82657cc4c87b3a4c8caa8999da6348813a0120f9dde36737ff778b4e45f20f"
    sha256 cellar: :any_skip_relocation, ventura:        "bd82657cc4c87b3a4c8caa8999da6348813a0120f9dde36737ff778b4e45f20f"
    sha256 cellar: :any_skip_relocation, monterey:       "bd82657cc4c87b3a4c8caa8999da6348813a0120f9dde36737ff778b4e45f20f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c22aea3141d38c78f0f4cebf19854018dd9caae6716ccbbc82cdc2f39610d8f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    port = free_port

    fork do
      exec bin"ungit", "--no-launchBrowser", "--port=#{port}"
    end
    sleep 15

    assert_includes shell_output("curl -s 127.0.0.1:#{port}"), "<title>ungit<title>"
  end
end