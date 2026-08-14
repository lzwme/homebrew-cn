class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API written in Rust"
  homepage "https://github.com/fioletoven/b4n"
  url "https://ghfast.top/https://github.com/fioletoven/b4n/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "8764b07ae11c0474337112b5da1387c01cb137b71d4def93b0eeee72db9af495"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40974eb4865721db8ea01edf42c79b4a109d5e78d9d130ee344453a9b58dfc4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13f85c15b6afcba269790cbf0fb2e8a8644eded2a3bf7db2f6c2ec063d720ec4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d708b6b7065da37c7ea33cddf227d36a151d123e12f66b422dcfea305238e5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "074cfd06b108c257ef830606fa3dc8a66c8fa081134850e82c2f690ff83febf7"
    sha256 cellar: :any,                 arm64_linux:   "4a2081aca456f3e5a710bd2a12ccc6adec06435995a341b34ade1c87d786d6b5"
    sha256 cellar: :any,                 x86_64_linux:  "e25a5e93cfaca959479400f4f5a7019f4df32a4da601ed84a1a163f1b61a3a87"
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