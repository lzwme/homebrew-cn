class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.8.0",
      revision: "0fb4b6111b5af63017ecca66534e2d6d437ad455"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e833a916638b9e1aa4cc31b2574c3d8c6973c1990652f39e699f19d962a14853"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e833a916638b9e1aa4cc31b2574c3d8c6973c1990652f39e699f19d962a14853"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e833a916638b9e1aa4cc31b2574c3d8c6973c1990652f39e699f19d962a14853"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e833a916638b9e1aa4cc31b2574c3d8c6973c1990652f39e699f19d962a14853"
    sha256 cellar: :any_skip_relocation, sonoma:        "38de46b4af789f72803ffee05b444faec98628e8f74978393b67c1cbc1b52089"
    sha256 cellar: :any_skip_relocation, ventura:       "38de46b4af789f72803ffee05b444faec98628e8f74978393b67c1cbc1b52089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c71fd91cd5a3fd0f9c5a66ab6d30f784edeb223a9c0f4213d7b2405aac25ff7"
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