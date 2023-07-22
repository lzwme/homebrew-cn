class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghproxy.com/https://github.com/lmorg/murex/archive/refs/tags/v4.4.9000.tar.gz"
  sha256 "05d18960dbd8a602c5187f33791ebbbc45cd2c4e1c86ea543ef8b24aa2df67ad"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a033dc3f2f85db9d1f4d20eb5b6f666cd35391ea8c1a86d962d389ec20888405"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6027f328727bf3fc35ef5beeaf14289ecfb3e444cf12ffd30096eda517c80ba1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb1ff652c155b5a9a974278ba4fd1f9c7dcab1b9a138e4ea77c1f9a4dae5bc5b"
    sha256 cellar: :any_skip_relocation, ventura:        "3a6c37b9f5874b8b5f2f0e2bc0a2497cdc60987eff7187186eef454085154723"
    sha256 cellar: :any_skip_relocation, monterey:       "4ef15b0b88013c34b90c4416d6ce6e88331ac2a0a5d32d8521723504697db0ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fabc92d77f763d229307e35f95b654b1e92ef03ce937f40bbbc5bf7d5e9b114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "767448537e235e9e3d7a6ea65086a86d69e3ace90e6a2bd18a1a076970ed3b10"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end