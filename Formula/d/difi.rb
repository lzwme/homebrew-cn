class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/xguot/difi"
  url "https://ghfast.top/https://github.com/xguot/difi/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "4b0b12334d0d11ed4dab5cefd3e8ada5a464b66871e15c9ac67761ea23b81c4a"
  license "MIT"
  head "https://github.com/xguot/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0241181354ebb21eee07d59a6ba120f33f9e0033dee0cb47245fb6834bc30c3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0241181354ebb21eee07d59a6ba120f33f9e0033dee0cb47245fb6834bc30c3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0241181354ebb21eee07d59a6ba120f33f9e0033dee0cb47245fb6834bc30c3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d3454159e0386cb7b6aecd472e7f10be347e1b98111abfe0d2aee06b7b4d342"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bd28a10a9d1476a1e1289486938896bff791edb79d5f7ee9fa22841409b071b"
    sha256 cellar: :any,                 x86_64_linux:  "f9ffbf739a8e433256c4f239c6ff099dd3ec8b69bc74dd51c51b4359ae5c65ea"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/difi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/difi -version")

    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test"

    (testpath/"file.txt").write("one")
    system "git", "add", "file.txt"
    system "git", "commit", "-m", "init"

    File.write(testpath/"file.txt", "two")
    system "git", "commit", "-am", "change"

    output = shell_output("#{bin}/difi --plain HEAD~1")
    assert_match "file.txt", output
  end
end