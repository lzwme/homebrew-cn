class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.7.5",
      revision: "9af9b25e227f7d1c8927734cfab1c27037a6084d"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ffffdb1d97fa02785784c01429aab8c242dcf888da41e34a69a96fa8f58d46d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ffffdb1d97fa02785784c01429aab8c242dcf888da41e34a69a96fa8f58d46d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ffffdb1d97fa02785784c01429aab8c242dcf888da41e34a69a96fa8f58d46d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddb609ff907e6a861b67088d821e828856e3b4563994977733d38f26ee1a836a"
    sha256 cellar: :any_skip_relocation, ventura:       "ddb609ff907e6a861b67088d821e828856e3b4563994977733d38f26ee1a836a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b39ee983fb8b61f52080105b8832f301f09b0d40fb8f704450a177b5f430386"
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