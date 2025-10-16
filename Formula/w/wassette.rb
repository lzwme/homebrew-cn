class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://github.com/microsoft/wassette"
  url "https://ghfast.top/https://github.com/microsoft/wassette/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "255e553c9d68cbc34b2b8d2e21650763b8878ae54454d1c17f8144f15f2fe13c"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8129b018a65b979a9d624ff37936864d9f8070e39e6f23e48b7b5dfaf918ede"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3742f95a49defe2ae42215f4589de42f3cf05d5962ea87c47899952f4874341"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93ec8445be4fd971290a5e9cf57d32c3bbaa7b3b7ec97dec5bd4c8ebd4be2518"
    sha256 cellar: :any_skip_relocation, sonoma:        "640dfd173f410727b086dca7f9d3000e3ce5605b72ccc0ab866b0199104900b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff3d3fdac281c6121397f63b642a9b8fcee3c61ebdf91e5fbe1ad2002d607a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7d2f54e00921d6a0560d11af22f1c8c6271b9d0d543537821939c760aa8a470"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end