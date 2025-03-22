class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.32.tar.gz"
  sha256 "960510f95d7a76ce8ee0b8d8dd8d579f662e732a2ad55a8a0e132d94288d9513"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa26b928f6aed8094b75b691faed1bac9fb3c9d7c7fc64483836ecfcea68c42c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa26b928f6aed8094b75b691faed1bac9fb3c9d7c7fc64483836ecfcea68c42c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa26b928f6aed8094b75b691faed1bac9fb3c9d7c7fc64483836ecfcea68c42c"
    sha256 cellar: :any_skip_relocation, sonoma:        "84e7a70a50129112125a5dfd717ae3d80013612fde1f943d6a8e22afc55270d0"
    sha256 cellar: :any_skip_relocation, ventura:       "84e7a70a50129112125a5dfd717ae3d80013612fde1f943d6a8e22afc55270d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "652af119bdab721a6c6371eb87e8a6aa5d7acf36467a111468af3098a190d3c7"
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