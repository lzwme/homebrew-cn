class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.26.tar.gz"
  sha256 "b0af11a547856275b8fc8af091a4b788208cdf8fa2452a0b2289e31b503bf4fd"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c901719b81f8573208f2849ae71e79ab804929229cafac223eb75e7e58e7a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c901719b81f8573208f2849ae71e79ab804929229cafac223eb75e7e58e7a80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c901719b81f8573208f2849ae71e79ab804929229cafac223eb75e7e58e7a80"
    sha256 cellar: :any_skip_relocation, sonoma:        "56a3c4362301053f8261eecdcc05cb6f047db47bd9f43de4cf7e112970ff03bb"
    sha256 cellar: :any_skip_relocation, ventura:       "56a3c4362301053f8261eecdcc05cb6f047db47bd9f43de4cf7e112970ff03bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ee84ca39a01360b83c448104bbe025cee2e310682c8ad96113a4d169b5b5b21"
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