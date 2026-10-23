class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.24.23.tar.gz"
  sha256 "8ba765ce506b96c5f15ba022097e7b31a9366332a56c2608420aed6439b3b53b"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77ec502b8b642d506e6fbf2a995f95a08751df256ba1bbb33f6775809554c26d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77ec502b8b642d506e6fbf2a995f95a08751df256ba1bbb33f6775809554c26d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "77ec502b8b642d506e6fbf2a995f95a08751df256ba1bbb33f6775809554c26d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6d0e0d522d49abeae8710e71d5e26dbffc2d689d57d8e0ab682a5e0a1991d36"
    sha256 cellar: :any,                 x86_64_linux:      "b4dd278e1e3b48f05db341a77267466fcff506205abad01d2ab69cd56ef5c387"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/minify"
    bash_completion.install "cmd/minify/bash_completion"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minify --version")

    (testpath/"test.html").write <<~HTML
      <div>
        <div>test1</div>
        <div>test2</div>
      </div>
    HTML
    assert_equal "<div><div>test1</div><div>test2</div></div>", shell_output("#{bin}/minify test.html")
  end
end