class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://ghfast.top/https://github.com/xyproto/algernon/archive/refs/tags/v1.17.8.tar.gz"
  sha256 "54a3b45ccc75266e831c60747b54baf176f060b08eac9663e5171772c10fbb4a"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46a0db8c31ce717b5d2663974e8ab9426e312567cda013ffacdade6c793a8d3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46a0db8c31ce717b5d2663974e8ab9426e312567cda013ffacdade6c793a8d3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46a0db8c31ce717b5d2663974e8ab9426e312567cda013ffacdade6c793a8d3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b628aafff73258adad8eb8bf38758102a8695e358d40d0c4f41dff14f2d20d25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdb0ae384a71ad561b241960bbad12fdd2da5f47eeea5f21b3919cf5d71128e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f58ac119ef2a7bd85701afe6128e55924f7dfb2028e2a4dcd4847400987b9386"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = spawn bin/"algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db", "--addr", ":#{port}"
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end