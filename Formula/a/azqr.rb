class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.3.1.0",
      revision: "4439f1e35aa07c554f27559b11bb233b3a44964d"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3770a00284e5e07fb0de5256562dd769868f4e3f61ad1a7e976e8861ffd3e795"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3770a00284e5e07fb0de5256562dd769868f4e3f61ad1a7e976e8861ffd3e795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3770a00284e5e07fb0de5256562dd769868f4e3f61ad1a7e976e8861ffd3e795"
    sha256 cellar: :any_skip_relocation, sonoma:        "997600fb793f38ce50580d312a6b87974e27ef33ab821cc791126b20069f3fbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74d9cb1c1b293c261c9667ad493a2285b516ce871e09b27ce1efc935f8bacf6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b60a3ecdf8abe35ac8f7d90c5300f6be62d8e6328f3e530337ce731543eeea0"
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