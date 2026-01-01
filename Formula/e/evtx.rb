class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://ghfast.top/https://github.com/omerbenamram/evtx/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c5c88de46921325a2f32abc8f621be115959a589823d881f9ad2c4ba4391811a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f1f211053bb3593a3504c63c59d8c3c3a7eedfce5c1477c8413ecbbe7b107c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80322e242f6d56c23a0bd393f2dde5f036399c9d841505301bf368e0d34f4d01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dad7c33a0da5b12d84979caf83cbd1884fb46e5484d2629c5eb632f727a8b65"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ce5bd9d0b20ccbfbdb0b7f5e5b1f4acdd98df2022be9e6d86a5789a99e57b46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1362f6279ff38a9296009dc863351dde6bb43c5b0acc485fbdc866eccd6b60aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb6f8e0979a1e121b66874596d19ae2997f82fb823713981b6cbf254f25ecc1b"
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