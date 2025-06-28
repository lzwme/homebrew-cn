class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.218.tar.gz"
  sha256 "4afb9b574c02039db7b599f87fde535ef416ee2d2d7e2aa1111988b5ba3bf61d"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa32827ed79412efec01bf7422dcbec538911f877054f31b1eb47025e5839352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa32827ed79412efec01bf7422dcbec538911f877054f31b1eb47025e5839352"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa32827ed79412efec01bf7422dcbec538911f877054f31b1eb47025e5839352"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a2c9c21981778f63ab3c039c859477bdc34ab4aa3911df53dcb67ea029ae517"
    sha256 cellar: :any_skip_relocation, ventura:       "5a2c9c21981778f63ab3c039c859477bdc34ab4aa3911df53dcb67ea029ae517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee97ee8930576376d7ce6e3e66851de9071e944b3f8c6d4712ceeeeb56a7887f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fabric-ai --version")

    (testpath".configfabric.env").write("t\n")
    output = shell_output("#{bin}fabric-ai --dry-run < devnull 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end