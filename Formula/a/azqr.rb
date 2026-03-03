class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.3.0.1",
      revision: "a98a9fde1deac31f3ae82cab826d06755acf021d"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa4e229bb4f8c93c8926e773addd17ca868dc8f7632046a6106dc980604cff2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa4e229bb4f8c93c8926e773addd17ca868dc8f7632046a6106dc980604cff2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa4e229bb4f8c93c8926e773addd17ca868dc8f7632046a6106dc980604cff2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6274a3b3b3d53c9af3bddb7fc5f507f93691c9ae4ce3c1a9c42f9276eec0c6d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0684b4293d40604cbeb61a5db62c0eaddceca4cb28d6abe78b5f12aaaa59506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb9b1ca5a1c7d6071fd060a618c146a0ce717b346cf631ec7aab2967ae64fc50"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end