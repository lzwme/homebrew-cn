class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.15.1",
      revision: "5b156e9f54a8a514a8275d042b40af9b6518f729"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad29627db77e69bafb9558742666d48ad9c18c8501141f309722affbed3c6f1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc3aee862250e2ca23c037e5790ca129686cdf5566e16d5951a1c2b311dbce7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe0a4dde8b3f949f897294f35b9aea8af48538fa31b247534519a532b94c3844"
    sha256 cellar: :any_skip_relocation, sonoma:        "935f90ec794c9e5460cf1fd9414ce6cc00147770eca2f35bbaead801ec3b9be4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71369b4243ae2d0bd6dda71ac4604f5b1fb8b39deb36a09b0bc521754c97ba7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de21e30e9a51f9bb06ea3604c123e3d41cf1484600b551f4de93a9c2aa4518ae"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end