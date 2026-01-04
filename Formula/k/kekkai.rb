class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://ghfast.top/https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "8bf0fcadcdd639254195e6d09c47cdb6c9f5e2d7457b98cf98add572fb5c0cd7"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "589bc210e39fc54cc98dcae9ab661b48a9dd910a25497ef6cfd7134ebb79ef1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "589bc210e39fc54cc98dcae9ab661b48a9dd910a25497ef6cfd7134ebb79ef1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "589bc210e39fc54cc98dcae9ab661b48a9dd910a25497ef6cfd7134ebb79ef1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ae013e3c14d8a2dc266610b17c0be63ee788fb7b1728b5965873bc67daf620c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9278cfb7eeb7d0de4cac6b266d68353e866302dcb2f3ccd5c7e4d5febbe0c6f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d88a23c78ee23f2eb4971ef1164da8f9780589be6651aa8fc471cc2f078dba"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/catatsuy/kekkai/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kekkai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kekkai version")

    system bin/"kekkai", "generate", "--output", "kekkai-manifest.json"
    assert_match "files", (testpath/"kekkai-manifest.json").read
  end
end