class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.68.tar.gz"
  sha256 "f9d7adabf5ff873f3445ac66e292fc67d31017093003f145ea40a68cadd3a429"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaad11bcc266dc2d39e49e90f0c45e3b5569c45175dfb05683760f5a14c7ec39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baca8c109d12e872c01f475c62889676bc7c327f2664528819f2a7c90788a5fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065a7122dc255ac53a4b118e5e6e104c78df499a9f57f707e3c02533e7427976"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3960e90ce04c9b63168b9e1bad0648fe548d9807d2f32672964d2d5aa1aee12"
    sha256 cellar: :any,                 arm64_linux:   "9702bdc9e3087184f8e4be81b9d763cfeb1248e57a9a110bfe2a1db5bb41523a"
    sha256 cellar: :any,                 x86_64_linux:  "4694b6d6031739bb8ed0497f8ca577c430fdb35fa0461574686dcb9b4adf785c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end