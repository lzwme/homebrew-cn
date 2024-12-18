class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https:github.comvladkensmacmon"
  url "https:github.comvladkensmacmonarchiverefstagsv0.4.2.tar.gz"
  sha256 "ef1fcd6096ef6f6d4f8066eb6049a4b264f6af1efe257050a51c37eba08c3eee"
  license "MIT"
  head "https:github.comvladkensmacmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d447feffe80bb1fb0bcd49262c6edcbd8c93774564e8198c8a558ff8c27e1e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c307df1059b812bded3c65daa2cea2a6527934a59ed87e5dbdddf198c074064"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dbd2ed6341b2dc4580f72d3f7afe1e8c5b6d5024ab340814e17776f4bad4f68"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}macmon --version")
    assert_match "Failed to get channels", shell_output("#{bin}macmon debug 2>&1", 1)
  end
end