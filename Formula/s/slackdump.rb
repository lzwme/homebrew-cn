class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https:github.comrusqslackdump"
  url "https:github.comrusqslackdumparchiverefstagsv2.5.12.tar.gz"
  sha256 "f68f8edf78bd1c959217a69cd9c895e64fba3e4e69084f0fddc286615b1d150a"
  license "GPL-3.0-only"
  head "https:github.comrusqslackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a24beef5ee1ae066d96951f3c6488cfc0b6e5c00c9246070d26dd62d4fe08e7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a24beef5ee1ae066d96951f3c6488cfc0b6e5c00c9246070d26dd62d4fe08e7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a24beef5ee1ae066d96951f3c6488cfc0b6e5c00c9246070d26dd62d4fe08e7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c915d5a962afecc08bf2886a2afef3745a0c9edc71f4bc84adf21f9aa90214a5"
    sha256 cellar: :any_skip_relocation, ventura:       "c915d5a962afecc08bf2886a2afef3745a0c9edc71f4bc84adf21f9aa90214a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79df357913866ea71bd5262de507790701de5e0e89e91e3cf64236aed14532a"
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
    assert_match version.to_s, shell_output(bin"slackdump -V")

    assert_match "You have been logged out.", shell_output(bin"slackdump -auth-reset 2>&1")
  end
end