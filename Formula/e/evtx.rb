class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://ghfast.top/https://github.com/omerbenamram/evtx/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "51bdafee164fdaa25645acce3b79346736b7547734695cec7a24dbb833298516"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49593a1a22b89efad98c424ad44a8c17b650a01d4b584b943d4c73cdde055da0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4e6817c3dbb88f03847bee9df24f9182fe2e793084a4a41ab3fdf6a8ae0840f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc63117c2e41a2cb115cff516b322bd3b20827b8ffd268aa28bc408d091ca5e8"
    sha256 cellar: :any,                 arm64_linux:       "4c0850e5b28fc6257716c2b6fc5c1e66c48ab6168c789c626af5e5bd72542a25"
    sha256 cellar: :any,                 x86_64_linux:      "451fa936f0be8a0b6d5c1cf215de5c190206b5b8a057df47d867d9e468d27527"
  end

  depends_on "rust" => :build

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