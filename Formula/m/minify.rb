class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.24.19.tar.gz"
  sha256 "7c3759e8d98c060efabfa9a49def043f7315d82b363eca2e0563ca6bf87ac20a"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "abf4f92408d45082814fd30954a2af00ffd5064548b4b6eea6429472e4dfb3e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abf4f92408d45082814fd30954a2af00ffd5064548b4b6eea6429472e4dfb3e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "abf4f92408d45082814fd30954a2af00ffd5064548b4b6eea6429472e4dfb3e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "48c435b4d4982bbd1f3e34327cd3cfb8432954e292b7fb400379381377c06a43"
    sha256 cellar: :any,                 x86_64_linux:      "24a3c0782a160765453f90a9a7419c33e9bf66aa131f6b40b133182988b030f7"
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