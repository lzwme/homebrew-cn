class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/k6/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "6976de6fb52b09b84fe5b1d849dc6b197cb9127a682a12beb2be70eca74b39cc"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66d29e92973717867b9e1fc04e6a01263ce89945827e79b46553886d1f98f92a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66d29e92973717867b9e1fc04e6a01263ce89945827e79b46553886d1f98f92a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66d29e92973717867b9e1fc04e6a01263ce89945827e79b46553886d1f98f92a"
    sha256 cellar: :any_skip_relocation, sonoma:        "737e4eeb6be4efa5fc770d57abcf11eaf7d3a68d072c19fa8ac4c9102856c41b"
    sha256 cellar: :any_skip_relocation, ventura:       "737e4eeb6be4efa5fc770d57abcf11eaf7d3a68d072c19fa8ac4c9102856c41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0a0a5e7c767921691d16a4d2233cc8a4a1f1ea40d1b97edf1cc3c1624bccb65"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")

    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end