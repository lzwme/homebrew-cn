class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://ghproxy.com/https://github.com/turbot/steampipe/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "ea9ea652b1b66259e0b1f2d3665df62a58657b950d9d3e7183d9951cacc34ee9"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa0ace3189f689587029758256bffc777ecd4ebd92462e35f2f145eb96813e1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73c5e3632f1af8872d1a994b368f719ae5a56c83832f1925abaa55e015410422"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fa3f7343707ca2b3f1857e169fa6903de6ab5bf8b0a8373a15329ac4900f0b7"
    sha256 cellar: :any_skip_relocation, ventura:        "d009f872993c536d0c5eefd3029988cc0f7f67c1256ef88ee61321a14c9bde14"
    sha256 cellar: :any_skip_relocation, monterey:       "9574c0d73f149a58d9d36df3968c765b013280fa56e35c5bdb3b9df77a8a3fed"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaba13cf7d1cfed416a5911d3926ea78e1dada5a543c5e6ba7f9ec71812db92e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "905836ecec609d091829145841d13f425e304f248e0a3caeef89e60a370cd6d8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    output = shell_output(bin/"steampipe service status 2>&1")
    if OS.mac?
      assert_match "Error: could not create installation directory", output
    else # Linux
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end