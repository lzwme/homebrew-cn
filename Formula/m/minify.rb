class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.24.2.tar.gz"
  sha256 "e3a26599994dbab9a4f6d6fbaa8238f215b230418cc8e686bcb9043aeae3d822"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a1df273c587b30b0c699714fa87c095906d66ff491979d5d319220da5a50c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0a1df273c587b30b0c699714fa87c095906d66ff491979d5d319220da5a50c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0a1df273c587b30b0c699714fa87c095906d66ff491979d5d319220da5a50c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8848268048cade0c293b86a47154bcf5587b19f3d0e50e734b2ef671a78cd37d"
    sha256 cellar: :any_skip_relocation, ventura:       "8848268048cade0c293b86a47154bcf5587b19f3d0e50e734b2ef671a78cd37d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e33b97027bb11eb1fe5fc7091819f702fee4e6a75e55e2f0d8a5eda9c3137868"
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