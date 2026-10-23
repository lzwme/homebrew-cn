class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://ghfast.top/https://github.com/omerbenamram/evtx/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "618d66d3bf7cb151260b0d3f7e9c42229b6af3141abec5670040c62abb1f3e2a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f93ceb6d4490e491e561b777675193c0ac0f54d89b288d9dcbef69c01bcc0310"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "615443e1bb8e9288a83597eef82f412ad437f552febb4811565d411d317e0d56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b15d89502f151bc68d77baced5f966e7f7f093ecb471255dee184f97e8551625"
    sha256 cellar: :any,                 arm64_linux:       "c3f022434aed6551b6aa55a9d9ef12071f765421c64508c7b67ac836ff827409"
    sha256 cellar: :any,                 x86_64_linux:      "1e693713019a879c7811577a5bf5dbe393ec4ec2b6cae35683dfadcdb5874d34"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "samples"
  end

  test do
    cp pkgshare/"samples/issue_201.evtx", testpath
    assert_match "Remote-ManagementShell-Unknown",
      shell_output("#{bin}/evtx_dump #{pkgshare}/samples/issue_201.evtx")

    assert_match "EVTX Parser #{version}", shell_output("#{bin}/evtx_dump --version")
  end
end