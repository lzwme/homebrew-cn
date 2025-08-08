class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https://github.com/mandiant/GoReSym"
  url "https://ghfast.top/https://github.com/mandiant/GoReSym/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "8109df3c0ea5798a8a77c29cd8bc41a74217ececa147647c624fa45505f1ea24"
  license "MIT"
  head "https://github.com/mandiant/GoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d95afffe8cdc77c33259ecdcef922c01cede46ec5997d965548925186e30f89f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d95afffe8cdc77c33259ecdcef922c01cede46ec5997d965548925186e30f89f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d95afffe8cdc77c33259ecdcef922c01cede46ec5997d965548925186e30f89f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ddd7523694d96f7ca9cef349b2f2abd92a04a1a08049b17b5777cadf0de5ef5"
    sha256 cellar: :any_skip_relocation, ventura:       "4ddd7523694d96f7ca9cef349b2f2abd92a04a1a08049b17b5777cadf0de5ef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "895c128646081f43a159810ff8f71922181a1e49c50e56ecd9ec7aeed46b9ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9916b4b8cc7cc28cdc90bd9e86ba2eb9d6e2992e862bfa7e83946751e5128406"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/goresym '#{bin}/goresym'"))
    assert_equal json_output["BuildInfo"]["Main"]["Path"], "github.com/mandiant/GoReSym"
  end
end