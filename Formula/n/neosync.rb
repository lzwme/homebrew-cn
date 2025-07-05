class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://ghfast.top/https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.40.tar.gz"
  sha256 "3c6ed6363e7822c22e584f611516f9117d194822cc0bd30352a786dfbd96bc4e"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eab17fcb4cfb26602f49bbc2eee778c73530074431a51f57c9b8216077466413"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eab17fcb4cfb26602f49bbc2eee778c73530074431a51f57c9b8216077466413"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eab17fcb4cfb26602f49bbc2eee778c73530074431a51f57c9b8216077466413"
    sha256 cellar: :any_skip_relocation, sonoma:        "1286f126db3ae795dc91a3014ee33bdc3382f44a53bd23acf35e5a62b7374b0e"
    sha256 cellar: :any_skip_relocation, ventura:       "1286f126db3ae795dc91a3014ee33bdc3382f44a53bd23acf35e5a62b7374b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04642ea1d2c503ac77e68975c1d430fe336595af2a792222f70ddf4234bd1be8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end