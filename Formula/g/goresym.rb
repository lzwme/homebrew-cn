class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https://github.com/mandiant/GoReSym"
  url "https://ghproxy.com/https://github.com/mandiant/GoReSym/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "2f5409cb875e053ad0866b97152d6a6353c05d84db4959021cb88ec2a1e74c1b"
  license "MIT"
  head "https://github.com/mandiant/GoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be759944a0ef2237921fa66b17f8a6ece362450471f5420b69d78eed3ae6bc95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be759944a0ef2237921fa66b17f8a6ece362450471f5420b69d78eed3ae6bc95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be759944a0ef2237921fa66b17f8a6ece362450471f5420b69d78eed3ae6bc95"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d42c461ff9c96d7232e5a638b57606a1982b6f2e50a1f55b8f985a7134342c6"
    sha256 cellar: :any_skip_relocation, ventura:        "6d42c461ff9c96d7232e5a638b57606a1982b6f2e50a1f55b8f985a7134342c6"
    sha256 cellar: :any_skip_relocation, monterey:       "6d42c461ff9c96d7232e5a638b57606a1982b6f2e50a1f55b8f985a7134342c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8031bd4313fa2fc094a6d9d5a51a81318f9b07793f243c398fa1b199d28d217f"
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