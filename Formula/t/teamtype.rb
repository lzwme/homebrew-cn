class Teamtype < Formula
  desc "Peer-to-peer, editor-agnostic collaborative editing of local text files"
  homepage "https://github.com/teamtype/teamtype"
  url "https://ghfast.top/https://github.com/teamtype/teamtype/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "8503411b340f00456ac6c1d586637de35a35886b7addbf2cec06816e05bc9873"
  license "AGPL-3.0-or-later"
  head "https://github.com/teamtype/teamtype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d39d6ecbb4bb70542dfde014f959aa7e4c1e7c5f95822d3d3ac6810460a02a07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d41b7a993a5c110dae6d034679896a50d7b27b0dfd33f26f722a375d691f8bb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3ff4768d0e652f315ec87513bf75d0f6728fce3e1e59e32054b2d09b0b74043"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2fc48f5d63a62a300a526d7747d70a0c9ec202690bd65f9b873f61659fcdd1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea77190f8938553d345df84815eb2a34337149d2acc833877d4dbc8a7a7a7ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b31a298d71c652da37042224323882f02e669a6cc9f2f174375324aad275c5"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    cd "daemon" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teamtype --version")

    (testpath/".teamtype").mkpath
    expected = "For security reasons, the parent directory of the socket must only be accessible by the current user"
    assert_match expected, pipe_output("#{bin}/teamtype share 2>&1", "y", 1)
  end
end