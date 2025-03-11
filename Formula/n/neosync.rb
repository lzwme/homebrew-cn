class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.28.tar.gz"
  sha256 "c188a53b16d70752321ba297c70d7567bc2a486451fa6a5bb7780a624113886f"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f8adaea2eb60858a0b2427424e82d651143e9922e8eb5c48258b464c7f9605f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f8adaea2eb60858a0b2427424e82d651143e9922e8eb5c48258b464c7f9605f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f8adaea2eb60858a0b2427424e82d651143e9922e8eb5c48258b464c7f9605f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1611da2dcfee6aa9047fcc756eab968fca5de80e30541c4382ecbcf2e4afd34"
    sha256 cellar: :any_skip_relocation, ventura:       "d1611da2dcfee6aa9047fcc756eab968fca5de80e30541c4382ecbcf2e4afd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c19841b497c39e7afa6278e9291d09f854012e32c2c33cf42cd8a76dd2c2becd"
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