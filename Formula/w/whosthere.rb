class Whosthere < Formula
  desc "LAN discovery tool with a modern TUI written in Go"
  homepage "https://github.com/ramonvermeulen/whosthere"
  url "https://ghfast.top/https://github.com/ramonvermeulen/whosthere/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "fcb4230bab275f269bd2c93b0550d0a4dc73b075b15ba1cff32d1042148391be"
  license "Apache-2.0"
  head "https://github.com/ramonvermeulen/whosthere.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab03df912ffc5fda16f727e0d4ef4883e274559e136d218a6894990cd5c14b65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab03df912ffc5fda16f727e0d4ef4883e274559e136d218a6894990cd5c14b65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab03df912ffc5fda16f727e0d4ef4883e274559e136d218a6894990cd5c14b65"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b8cb6f4bc9bc48b1c5e0f2a95baf8563da073aab61c82f483363c2303ff783b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "498bd3a696fd9833fc95016642082c16db75a176dd1fbed9582bd5e9c28063ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1a14cb7fca6ccd2e0040f881d95bfdd662fec60368e96dddca5502823dcb058"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionStr=#{version}
      -X main.dateStr=#{time.iso8601}
    ]

    ldflags << "-X main.commitStr=#{Utils.git_short_head}" if build.head?
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whosthere --version")
    output = shell_output("#{bin}/whosthere --interface non_existing 2>&1", 1)
    assert_match "network_interface does not exist", output
  end
end