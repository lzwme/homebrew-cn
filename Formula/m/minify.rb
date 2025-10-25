class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.24.5.tar.gz"
  sha256 "4f384f6d7fd9509026f582b3a1e4afb30c1d8855efbc607a15a9943d9a73e362"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf6bb6788b179c576ffbf6ee70e90bfbd268095d685fb2ce849b76f1154c247f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf6bb6788b179c576ffbf6ee70e90bfbd268095d685fb2ce849b76f1154c247f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf6bb6788b179c576ffbf6ee70e90bfbd268095d685fb2ce849b76f1154c247f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1573413b45d3a43816f284e3876b2a03f43baf8b1c75df323ac0136b871716cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a823e1530967112f24f458414048942cdf596d77fc6d66e1ca79b40fbe2547c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3f91f79eeabecab095d893b328f63ff75570ac89c7f58915131ec2ef7a63c6a"
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