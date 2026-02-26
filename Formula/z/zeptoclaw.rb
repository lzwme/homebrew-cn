class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://ghfast.top/https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "eec202a03a1a7d2910e6df5bc33da60c3627cd3668d7f153b0dbcec4aa209698"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "484dfb3abea5f2a7ca214e5fd0ccfa9961f3805852f2485d4b00a23348700748"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4400aae1311a613d3a3bc05124c5e9d892b14dd23ff3caceac1fed6883cefe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2547a6af5d59432d19720f3aca681e9f29ae58c59073f6faef0fb097cf69fb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e339d4aee55dc188071ca7491f44c31e349e5f3b9a4f24eaff32accaf0ac4135"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aba43af77fb5325b868b3704bb746138c2c37d51e6c258f8e3354989f1c18ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6639e99c5e915c21b20ba5f8b6eaa8af309233cb1d01a0fb6c55612827f803c"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end