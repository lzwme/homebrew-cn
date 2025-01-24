class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.8.tar.gz"
  sha256 "781370441a19a1dc9bfb478e2c787e52adc8a8c9e54693abdfe8c52c74db4126"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b74545bdcf362d67277382ae1c41629c0290644c8792b39c4662d5b0d3a95394"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b74545bdcf362d67277382ae1c41629c0290644c8792b39c4662d5b0d3a95394"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b74545bdcf362d67277382ae1c41629c0290644c8792b39c4662d5b0d3a95394"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f7207a41e37fd6f740e45e4cecd2ba508fa3506ed3f757adcf3a2200f8d4547"
    sha256 cellar: :any_skip_relocation, ventura:       "0f7207a41e37fd6f740e45e4cecd2ba508fa3506ed3f757adcf3a2200f8d4547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b99849f58a598b5a3c17cffa6ac30013be424fe389acefbc27cd1195e4a57279"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end