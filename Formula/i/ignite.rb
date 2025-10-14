class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://ghfast.top/https://github.com/ignite/cli/archive/refs/tags/v29.6.0.tar.gz"
  sha256 "aa84aefcd349d32bf30e12f2a1c4e9caa83f0c9066e9899439ba5e0080d9be38"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3b5be4b4701f5055fc3f57b76449ed3133f39a8e1378a2b38efac3c4a0408a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32533fb9070c6f34817b5fcb60842d61aec38504a7793f18436db164f74df06d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2243727f2d29b2a14cdd528fc59363d3921a06183cd15ec34e67715b0ab2b74"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbbc88a7027886a8e50bbcc5894edaa1eabf2a8cbbde37439e38d22236bcbe15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ad6b25431fc66d1429c004caac8f6ff9f290431a0fb64262918cfff8b0c8ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2ae6729b7a59a0786b5ca74297d56dfdcc55640c2bb3152cb812f1ad1b992ca"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"mars/go.mod"
  end
end