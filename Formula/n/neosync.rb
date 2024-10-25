class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.81.tar.gz"
  sha256 "ed7c5db05df3206fc5f2e75ab8b116fb8b822475750341d082bfb86c13befda0"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "302107ede2be148a6622067f39f02e32159934b59cfec875f89c9d588de569a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "302107ede2be148a6622067f39f02e32159934b59cfec875f89c9d588de569a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "302107ede2be148a6622067f39f02e32159934b59cfec875f89c9d588de569a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "52ee734a45fdfa146cae4f1b8934a8e3a838977e03687b67d854117233c5b877"
    sha256 cellar: :any_skip_relocation, ventura:       "52ee734a45fdfa146cae4f1b8934a8e3a838977e03687b67d854117233c5b877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43ff540abe6ec38bab7e5d9de61d99501ec73a76123097a6028777b411528a09"
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
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end