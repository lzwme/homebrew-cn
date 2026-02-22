class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.24.9.tar.gz"
  sha256 "f6aebde4b802c8ef658b2284ecb7c4ac945aa62b9f3e59524dbe76e385992e22"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca52b8ba08cde9c1ca5449b9df792da4532f98be24ce3ac47d298a047e49839c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca52b8ba08cde9c1ca5449b9df792da4532f98be24ce3ac47d298a047e49839c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca52b8ba08cde9c1ca5449b9df792da4532f98be24ce3ac47d298a047e49839c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bc63d3eb5fa5b9415da6ec191c78c94eee2383d7dce7a5e8a79b21848b207f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b95b47007e10672898ff949063e4cf038fb94a7a28602a164f7c15f23d1e508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77034a282273ce27b22dc4d1473b3bc631839496134cf73d6be86a319d4e9bfa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/minify"
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