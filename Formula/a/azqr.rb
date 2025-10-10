class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.10.1",
      revision: "fa98f674ba626c40115afd569a12ecb7ef164a40"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d80964d2d3827b2786d53dff0f0b4e9072fbadf7143737662e383c0efe5d4a3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d80964d2d3827b2786d53dff0f0b4e9072fbadf7143737662e383c0efe5d4a3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d80964d2d3827b2786d53dff0f0b4e9072fbadf7143737662e383c0efe5d4a3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "939df40a981dde3aec791552a98a25d78c6a01446a5e627495a1632136c30aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13be7a321070acb9f53aca9305b67426a247eae6f83429003f5a102c7367b4ed"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end