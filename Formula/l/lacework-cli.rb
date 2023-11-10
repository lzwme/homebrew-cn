class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.38.0",
      revision: "912a31867de64638c0d18e6fe74ca13c894adb9b"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1c2c23a659bd38a351266e1ba0a2a200d1cf986229c0174a195a85b8eae8de3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b25e4fa604620f769cdcb1f2d45774ed528cf298f8d32da7960a817b3c8351df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c5f0257d21a8a694140a065803210431059b83c9aa14fa9e7b39a2898c208a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b0a7db21e48c636427af267bbc2cb75552b942e01859a988fc354b1d85f529e"
    sha256 cellar: :any_skip_relocation, ventura:        "516b96d47bd1e3e629f09fc47fe8504eca35e1b7cde08a47fae1ceaf9e479798"
    sha256 cellar: :any_skip_relocation, monterey:       "a4c08f15f5997811a6a68e9fe78297d57693c468054e8dd2af1be342e4f60a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "436a9a9665ae734ca36ed76041742340d253bf04f8eb6c666308c52aaf2dac0b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end