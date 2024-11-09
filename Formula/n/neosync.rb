class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.86.tar.gz"
  sha256 "d7419ca066327b288027e8daefb1e10f8f58b558103ebb49040c03aaee79d149"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a3d3ced82b192e9729b2fa28df639df0bad365ae4b1591c3f8de058788dca17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a3d3ced82b192e9729b2fa28df639df0bad365ae4b1591c3f8de058788dca17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a3d3ced82b192e9729b2fa28df639df0bad365ae4b1591c3f8de058788dca17"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bb14207771664dd74d783c1435086720ceeda26f02b29880894c791b028f732"
    sha256 cellar: :any_skip_relocation, ventura:       "6bb14207771664dd74d783c1435086720ceeda26f02b29880894c791b028f732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e31bad445893e2ae383a54f37765f872f056b752f7f5ec6bacb3f6ea5747f21"
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
    assert_match "ERRO Unable to retrieve account id", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end