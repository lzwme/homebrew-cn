class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.19.tar.gz"
  sha256 "068f293ae7135b3b941f307f22340996ddfa3beef641daee9744f78a32e660b9"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d95797e84b36b5d7a4a5ae062085bbd7604f13078467cffb364e4a28b5a2b51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d95797e84b36b5d7a4a5ae062085bbd7604f13078467cffb364e4a28b5a2b51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d95797e84b36b5d7a4a5ae062085bbd7604f13078467cffb364e4a28b5a2b51"
    sha256 cellar: :any_skip_relocation, sonoma:        "b58731cddee55c91a403cc73e6069948dcaed30999cd340d6a9268c2b3771889"
    sha256 cellar: :any_skip_relocation, ventura:       "b58731cddee55c91a403cc73e6069948dcaed30999cd340d6a9268c2b3771889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3454d84595975b18da5067289747812f1931287391e5e5190e9059c7ce56d4f"
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