class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.31.tar.gz"
  sha256 "45b6af6c8a19f0c01966fde2dfb0f1f9131a3c20e113dd16be8adaef786559c9"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0299b77b89c561f94347ef12c49f163f942dbc4c810f754f305a11abe940954"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a039b5767082dba64cccc195c6dfc11dd5ca6d89e7a4b8f2317de71edb73f815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e97d988e92aea00617682b0da8dff216cffa22cb89a2b5751aa1338a3bad254"
    sha256 cellar: :any_skip_relocation, sonoma:         "d261b3e5add8f755eb3f5ae62b5abadd37fd1db4dcc767eb66350c638654b039"
    sha256 cellar: :any_skip_relocation, ventura:        "307b8f7c39ab894ddd790bc89ed0829bfe2b26ccc8819425275a87b67d9421b2"
    sha256 cellar: :any_skip_relocation, monterey:       "ebeff11d8392eaa01bd49294d74a111ae27e6bfe2032df0102a2a97527ac3c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eb9f5d46e00d6375ecf1d2ec2253ecbd374a7219fa83cb8b5cfa697561f6c76"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end