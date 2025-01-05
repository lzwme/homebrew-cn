class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https:github.comrusqslackdump"
  url "https:github.comrusqslackdumparchiverefstagsv3.0.1.tar.gz"
  sha256 "8d64fbde89fadf709026abdd3c78f74e7f48858b9535bedef89df5c5744b6661"
  license "GPL-3.0-only"
  head "https:github.comrusqslackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2af68f5b9c750290cc131058ba711aaa1cc4944b93f6eecf0c7706858e125dc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2af68f5b9c750290cc131058ba711aaa1cc4944b93f6eecf0c7706858e125dc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2af68f5b9c750290cc131058ba711aaa1cc4944b93f6eecf0c7706858e125dc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2046e7c93562de37cb7ba5454f25e7432dfbdee9cf2ba1db98ad84bf1ef1096c"
    sha256 cellar: :any_skip_relocation, ventura:       "2046e7c93562de37cb7ba5454f25e7432dfbdee9cf2ba1db98ad84bf1ef1096c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a94189aa468ace05730bc16d93e6a43279c580bcd713e974f83df6553b75152"
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