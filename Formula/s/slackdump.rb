class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https:github.comrusqslackdump"
  url "https:github.comrusqslackdumparchiverefstagsv2.5.13.tar.gz"
  sha256 "dd9eaccdb89c2a4fe43becf9beb7cd55a54f658d14abec871abc3304080a544e"
  license "GPL-3.0-only"
  head "https:github.comrusqslackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbaa32b00f147a4de223ba06d68a5833b4b7fbe1b321f88b8d2a23499c582c61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbaa32b00f147a4de223ba06d68a5833b4b7fbe1b321f88b8d2a23499c582c61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbaa32b00f147a4de223ba06d68a5833b4b7fbe1b321f88b8d2a23499c582c61"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e66019a0559be94ad98ba17de2647a3d4fe44d49620a8732dff211cfb0e3e50"
    sha256 cellar: :any_skip_relocation, ventura:       "3e66019a0559be94ad98ba17de2647a3d4fe44d49620a8732dff211cfb0e3e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1de375b9bb82a8e22b5c7d95cf1f367b2d6c01742ac178de84d2abfab1f189dc"
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