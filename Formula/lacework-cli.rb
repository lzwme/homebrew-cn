class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.20.0",
      revision: "2abf964c44cea6dd8a29ed86fb2524dff2a1fbc9"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4fa13fdd260db191cee95963382c90e99dfa414f487e3d5160ed720e122d571"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df3cbe397c6ca47a885776ac327c2e47895201f049cde1198f55fe1c7f9840a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97c7c1f64c81a9cb8eb3fc1afe304762590014efd7fcb445db44cfd558af3b1d"
    sha256 cellar: :any_skip_relocation, ventura:        "00c923eba0a100887e9b488163ddc4c51e1bf85486dd0c1bb6ce0923ce4d049c"
    sha256 cellar: :any_skip_relocation, monterey:       "c39f6a9c689e7a101a5634fb4702103419df92077c46679cee444aeeb4b0d4c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e09d31f101f23a84fb4660cd6df3f22a53d2df9cecfb7f496f2e3a8ef3ecbdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de033b02e1de14162325e613240cdacf8e37bb33af77a85852e2ae082f2e7c3b"
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