class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.24.21.tar.gz"
  sha256 "5ae6109c62a2e4da8f5a6f7b7f22711a1051fe03c687e6209a7b64322d79ae10"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0e01af16a3d359e2306c087ade31df672b7d05ce00f24d799efd15f827fb3207"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e01af16a3d359e2306c087ade31df672b7d05ce00f24d799efd15f827fb3207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e01af16a3d359e2306c087ade31df672b7d05ce00f24d799efd15f827fb3207"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b027db12d4720f2deef5613ed49a54848d7f23aacaf044f84c91b2fa3faadbff"
    sha256 cellar: :any,                 x86_64_linux:      "630bb0d1b46c171eebfafdf497b1b4d907703cea595b0e9c7b844a7f79f5df2f"
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