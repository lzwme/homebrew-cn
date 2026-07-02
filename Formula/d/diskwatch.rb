class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://ghfast.top/https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "f0060fe6b81d67937c68cadc1729f0cadb65c863a296759365dbf37fbf1e2d01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2de44c3085d8c4f27b98b66b60993be3277e29515cd2db4f52b6ee18e828ccc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72141f5d30813f5616b08c4ff7d03d293c015db51728bf9af97fa4fa2f0fc99b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "665b949379d0ebf35c471ec6b0bc9a136cecbcc2d35d04bcb1bd7f3aed2475ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "95c7c4c9512e752d296638076d065b2f95ceb05845ee8652a3f9b3eb2ab087c6"
    sha256 cellar: :any,                 arm64_linux:   "ec4a9af3a4722ab3f3fb2198b4727ded867be539ed0991fab734b2493f903bf8"
    sha256 cellar: :any,                 x86_64_linux:  "d152e67da03cde67ba0efd8392e3c8b94f3d55de8beae5384befe677f0620966"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end