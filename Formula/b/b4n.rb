class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API written in Rust"
  homepage "https://github.com/fioletoven/b4n"
  url "https://ghfast.top/https://github.com/fioletoven/b4n/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "4cd40d6bc08e69a880c924c290af90ad59b48211797dc8dc9daa586c362a2e90"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fc8fbbb891dbdb72330e1de46d358848fafbf3ba014d67aa0fbeef67959b345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01b39d277c6dcb63b22e09f35f670484123da57c30eb807a2510b07cc9792d89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0245557a655c9e8c2997c9591b1011ef2b4f156248a446002421d50380e4ea49"
    sha256 cellar: :any,                 arm64_linux:   "fe1cc82f26eec4a44a77b3430577cde53cfc0b9931b70c50e3d428a7fd19fdc4"
    sha256 cellar: :any,                 x86_64_linux:  "ed4f898c000499c4c400908cab1d7f2e02fce40d3b5cc2021423823e5a38a23e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # a cli will complain on incorrectly configured kube context or config file passed
    assert_match "Error: Kube context 'none' not found in configuration.",
                 shell_output("#{bin}/b4n --kube-config=/dev/null --context=none 2>&1", 1)
  end
end