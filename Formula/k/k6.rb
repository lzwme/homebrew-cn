class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/k6/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "ead9c77b5e7080bd4a6f3ad628e656500dd883fa9f2da690ad4439c5cb2c0d97"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "973def25cf7f920af410a372d2f6abf6b3f5952c4e42ec757e81f71e95ccb226"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "973def25cf7f920af410a372d2f6abf6b3f5952c4e42ec757e81f71e95ccb226"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "973def25cf7f920af410a372d2f6abf6b3f5952c4e42ec757e81f71e95ccb226"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8dfb40f111be91201f1dd923216d8570919ffd5a430a3dcedc0d4eca257aa71"
    sha256 cellar: :any_skip_relocation, ventura:       "e8dfb40f111be91201f1dd923216d8570919ffd5a430a3dcedc0d4eca257aa71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c644896f7eed313bcc552b3938e1cb238daab16b94737a7d775f8c1d24d3b5e8"
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