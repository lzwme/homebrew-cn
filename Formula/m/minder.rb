class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.51.tar.gz"
  sha256 "dca957c5161993d91e5ef2e7be3fc753d6f8abfe4dfa7fc175e07a2466ad2102"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a58e3755c3f6f6d5fca295fd90ed6d0f33560b05a61c96b4575da70e8db14de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ea360749419a2533c1626b147e913b44f6e844b91581546f79b7f8aafb9d9b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0e00c823ef69add0a8a40eb69baff96155bcf68122b509883027a6bd3621bd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "78a68a70cf1fcb7333e04ad694cfbd715a6e273c4ebaa3818193e10a1461b09a"
    sha256 cellar: :any_skip_relocation, ventura:        "915a5a8554bb368e6feac1e989b25f2e2e7f03f892d8e216c441b348eb65ad08"
    sha256 cellar: :any_skip_relocation, monterey:       "b31ca7b596f5a65508230fee0d1ee316f0f24af691c33d8eadc266b680c50928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6dc9789ac546bf7292d8cb6cf6a3edec3bed993c9840a4cc5d58dac10788967"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end