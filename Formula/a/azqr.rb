class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.12.1",
      revision: "a3e792656713f046d0242590d88ba5c63f09e3da"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32224a03eb1d48be0c063abf7161d180e0f524722b6bcfe508ea195cace9d080"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32224a03eb1d48be0c063abf7161d180e0f524722b6bcfe508ea195cace9d080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32224a03eb1d48be0c063abf7161d180e0f524722b6bcfe508ea195cace9d080"
    sha256 cellar: :any_skip_relocation, sonoma:        "c27cb4e6fa89798ad0b1028c8cfa8954540edcdebf1dd24d4c43ed98d275e5b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5f5f49b9b7ea64a3d5772bd31f8a66e643db718dcf38df8db52cf736aeb5a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f2a294f5f15addca6a228167905751c98a9e7efedbe018b96dae236eb95ea0a"
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