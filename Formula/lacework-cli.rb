class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.19.0",
      revision: "0b8664cca2190d2bf08b24c35ccd6ed4cabade12"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb0dbf4a160cf2e7b9e62bdf8447e3669e06ca55b9f26532c0e04d3fb52f6bc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc243276cabbbeef1c29c52993c2cb643980010fde23794107aeee0c74009f3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c965556d525fb1a9f98d328cccb1d0d1cc3f61f8ccf0be87cce63279040637f"
    sha256 cellar: :any_skip_relocation, ventura:        "de31c6da3939c5b9415480bec657ace1d0d3d0dd67b7dde7f06abc9994cf43f3"
    sha256 cellar: :any_skip_relocation, monterey:       "19c2f2cfd8a8c4e64c9f812683ecb3fbca755fde46b747184228af257feeb658"
    sha256 cellar: :any_skip_relocation, big_sur:        "21fb7ded07d2ac77445c08f1e2069035465576ce571d4da4dad6d585cdc9fbda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67a6093c30ebfe4ff293cbcd03b9221e1c7efb4e789fc4683b4d240d8a56ee42"
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