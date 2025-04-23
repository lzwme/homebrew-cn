class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.181.tar.gz"
  sha256 "3998e377d5529a3f6d7d5da2aa4bec85e47a9f60b45693cc1922441e19f800b5"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4475370b58cd8b7b8383d24d2727a9c1b34c72addbf09ca3528cfb64997f9a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4475370b58cd8b7b8383d24d2727a9c1b34c72addbf09ca3528cfb64997f9a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4475370b58cd8b7b8383d24d2727a9c1b34c72addbf09ca3528cfb64997f9a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ff9a85877ecd720720d042d7b68c43ae17c55b0dbc0468c1e7363a200f0149a"
    sha256 cellar: :any_skip_relocation, ventura:       "2ff9a85877ecd720720d042d7b68c43ae17c55b0dbc0468c1e7363a200f0149a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46de580abf24c4db22ef7426238f8e77970288d56b71bf7767fb3954f5ef57f2"
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