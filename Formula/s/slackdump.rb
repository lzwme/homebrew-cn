class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https:github.comrusqslackdump"
  url "https:github.comrusqslackdumparchiverefstagsv3.0.0.tar.gz"
  sha256 "9fea60451d9b070395bb342fe5482d4e6de34529557a81f32a312929eb177d24"
  license "GPL-3.0-only"
  head "https:github.comrusqslackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1540d6968c6c403e4e7f9d144d4373c9628250e498a258ffa5bc32a37ba0464e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1540d6968c6c403e4e7f9d144d4373c9628250e498a258ffa5bc32a37ba0464e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1540d6968c6c403e4e7f9d144d4373c9628250e498a258ffa5bc32a37ba0464e"
    sha256 cellar: :any_skip_relocation, sonoma:        "75f4f23761818bd09052a0c84a19fc23e6c10f05808e69e6756dadfdfd35ef0b"
    sha256 cellar: :any_skip_relocation, ventura:       "75f4f23761818bd09052a0c84a19fc23e6c10f05808e69e6756dadfdfd35ef0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1701191bb8414a9f708a8563fc1ac5789c0be764947148b9fa2a12a5e9e6762b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdslackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}slackdump version")

    output = shell_output("#{bin}slackdump workspace list 2>&1", 9)
    assert_match "ERROR 009 (User Error): no authenticated workspaces", output
  end
end