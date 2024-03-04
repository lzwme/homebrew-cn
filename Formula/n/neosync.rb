class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.3.51.tar.gz"
  sha256 "5f705dae63803f1424eb7c828d2bb85534993126e00c57d7268823dca642127f"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d516ae2f85e74647284795663a37ff61091e1bb7614b88ebe39e80cf70ce09c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6269551a49b2061dcc242a968215302ad2ad6d7d3d421c5edb796299938de106"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f119a78e08b1830caebda833104e10c8a53b26e681fc4a5471748938a075683"
    sha256 cellar: :any_skip_relocation, sonoma:         "807a2e39dc78c9dda47e52f08b99c8041edc0ce1c4a0a35ed33a04603121f1a2"
    sha256 cellar: :any_skip_relocation, ventura:        "63d52f70c85037e1bc514852213ea7396b71c7160b377794b4b2c30ebbcd435a"
    sha256 cellar: :any_skip_relocation, monterey:       "ecfc62bfaeb78f60dac12f6ae48bbb8a69a667582c94d0e0332a7dd35f5d1539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b162d5d06733c10d5a8e7486c827ac70c8aa6e1654a1d9e03ac331f8929a9bb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags: ldflags), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end