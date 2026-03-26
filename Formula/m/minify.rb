class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.24.11.tar.gz"
  sha256 "f43c2ec205d395483d3e731f13da01cb12003ca583030c349b3b6dcfd75615c9"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7b93cb900413c62cfb2aa16b16bca1571fa4b7330b9d8d905bcf47ce58fdcf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7b93cb900413c62cfb2aa16b16bca1571fa4b7330b9d8d905bcf47ce58fdcf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7b93cb900413c62cfb2aa16b16bca1571fa4b7330b9d8d905bcf47ce58fdcf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b121023995db88e77fd9a4f8e0a353dd75f49edf59e519cb28dad9bac34b687"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00e2f7f0b9e3a8460786d504a840ff7ec8e56e70e9d805490083d62fe7ae7d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d311217548ebb08f6c786e754a98d2de2d58169fd827503841d2ba184c135e2a"
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