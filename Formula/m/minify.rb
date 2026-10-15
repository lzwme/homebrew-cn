class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.24.20.tar.gz"
  sha256 "ef6eaec43bb0fb7c140e97278079f602c7c0150f44d2b74231cab3f53a3a091e"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17be35ccabbeb6662e6cece71ec78eeeec47f9f0682047f4a4eb4d33fd56c226"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "17be35ccabbeb6662e6cece71ec78eeeec47f9f0682047f4a4eb4d33fd56c226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17be35ccabbeb6662e6cece71ec78eeeec47f9f0682047f4a4eb4d33fd56c226"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "198d48f38c08d4c1cbb166306413ccb0b2166eb0cc7f047e411fc1a933b41203"
    sha256 cellar: :any,                 x86_64_linux:      "70dc6ca50b5e0ebee40cd46f0f0e94843699d232b692fe0b3ccc06a834b8e7ea"
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