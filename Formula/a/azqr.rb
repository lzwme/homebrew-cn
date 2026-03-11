class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.3.0.2",
      revision: "4af8859421e6931ce6c6f8b4205947229b186d48"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f73051f496dd1deeadeba52cfa5c7b88c7f3031174812bc9b0f80e57cf1ed33d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f73051f496dd1deeadeba52cfa5c7b88c7f3031174812bc9b0f80e57cf1ed33d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f73051f496dd1deeadeba52cfa5c7b88c7f3031174812bc9b0f80e57cf1ed33d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c420b5da6559a81203e16af0b1802e4962940b36fb0d6ea796b36bb10e0392fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7cd81e968cf0861141423e36f1efe30665f212609419d20d634c7c7b4945332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a6c164badfa28ced05ab682d4d4509356214193276c3ca3cfb18b8764530fb"
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