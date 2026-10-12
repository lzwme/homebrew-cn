class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://ghfast.top/https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.66.1.tar.gz"
  sha256 "75d82496e7e99a4ae58279efd37186ee5d10de9bb751077775487639c07185af"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e277cb254fc844733c5f933871d35aba510924f5e7c6d12d00638b4a96ddc5a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e277cb254fc844733c5f933871d35aba510924f5e7c6d12d00638b4a96ddc5a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e277cb254fc844733c5f933871d35aba510924f5e7c6d12d00638b4a96ddc5a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1f9a996f757d67434ffcf85497029488ef6fa9e96523d8218125fa92cf6caacb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "444d4d8bf3d1ef602171aec1dbe2ffa585ccac36ff7d2aec37af24bfbbd8011a"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit -v")

    system "git", "init", "--initial-branch=main"

    s = testpath/"test.txt"
    pid = spawn(bin/"lazygit", "-l", out: s.to_s, err: [:child, :out])
    sleep 2
    assert_match "Log file does not exist. Run `lazygit --debug` first to create the log file", s.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end