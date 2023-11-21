class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://ghproxy.com/https://github.com/temporalio/cli/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "23ec436df5bb5fcd3ad25ace1ba5fc5af9666f28426d47d8a64a7bdf660b069a"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d52a07e3a91ece1bab8c9450abd7628405fa6252009da73c3d9677f5658e4f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "522197ca06ffbae9129a353fdd47867f053852201874c8ea1f5fec3d1f819a49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a99a44df0f2d41fdd59221b58a7249d00b0b89d2f98caf891c28da7dbc0d1756"
    sha256 cellar: :any_skip_relocation, sonoma:         "773034cec65f2b147cf87dfa9669f2c210156bee32b0705d3c150fa462b02ee3"
    sha256 cellar: :any_skip_relocation, ventura:        "e63d7403deb9975f14515d9a64d9d3345e1643a2f1a200fb7987868480d6a8aa"
    sha256 cellar: :any_skip_relocation, monterey:       "fe14b885241ffde90e8fa39f90962e20be77e45908efcc5196b48525a5106d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afdbe4612683dd8966899c15b48f3f9d5518ee9b83ce5f5b481d39529c09f131"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/headers.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/temporal"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end