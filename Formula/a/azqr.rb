class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.7.1",
      revision: "f9da9a81ec5cca288d65999732b75bb4a91d3151"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50db9c0f7d26d93b0defd3a247450554326ca938b867954de62f3512c843e12f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50db9c0f7d26d93b0defd3a247450554326ca938b867954de62f3512c843e12f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50db9c0f7d26d93b0defd3a247450554326ca938b867954de62f3512c843e12f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ead1dca15a12ddd20233dc11889709e18af7fdee30badba0dff6095ea5ea108d"
    sha256 cellar: :any_skip_relocation, ventura:       "ead1dca15a12ddd20233dc11889709e18af7fdee30badba0dff6095ea5ea108d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e84ef03a70f77015100fc2dc0f161a279d05a4e668a967976578e381fad83f6"
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