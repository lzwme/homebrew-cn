class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.24.4.tar.gz"
  sha256 "0e5d728bbbe594389598d35c351c787619dc47fd23a01268e38b5d75c1a1c721"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec39d68d69518a86aaf9d492f1cdb82358acd49af4f32994910ed16e5f648df4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec39d68d69518a86aaf9d492f1cdb82358acd49af4f32994910ed16e5f648df4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec39d68d69518a86aaf9d492f1cdb82358acd49af4f32994910ed16e5f648df4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a70479b62f3b98c518ff03a68bfff8793c3d8d458977615febd75ef0bfb0c56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d68765173e8e3dda43e2c70120974a5cd8f78905e0317445c4f6d08aa6fc86a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f24198939972a1d8bc450b192c92b0a0cbd61918810198fd6c02d1d4fb8aab4a"
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