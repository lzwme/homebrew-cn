class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https:github.comrusqslackdump"
  url "https:github.comrusqslackdumparchiverefstagsv3.0.6.tar.gz"
  sha256 "d31780da1c7426c7d84b8c410976051a76e1608a09dbff8aee712a55e5a90397"
  license "GPL-3.0-only"
  head "https:github.comrusqslackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "604984a0a5c960c3d0be14c2e3b8742094931ab4d9855c92d1550d70a2239d65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "604984a0a5c960c3d0be14c2e3b8742094931ab4d9855c92d1550d70a2239d65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "604984a0a5c960c3d0be14c2e3b8742094931ab4d9855c92d1550d70a2239d65"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbe2c8b0be234d96571c828eee9126c7175b0d336eacfcdf1a100882f9b2f84e"
    sha256 cellar: :any_skip_relocation, ventura:       "bbe2c8b0be234d96571c828eee9126c7175b0d336eacfcdf1a100882f9b2f84e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9d26306755a5ac72d0d9f32a8e17d91c313961fb7afd88b3d470bf04ed7ee70"
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