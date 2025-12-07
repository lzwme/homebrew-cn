class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://ghfast.top/https://github.com/catatsuy/kekkai/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "03153702dbd6861a944327b098445b11e4d0de5999c58821f68c3eb8df9f8559"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2050c8c65943bc33fae6af64aaddb2f6258827f36d58eb20ca6e0b939688b06e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2050c8c65943bc33fae6af64aaddb2f6258827f36d58eb20ca6e0b939688b06e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2050c8c65943bc33fae6af64aaddb2f6258827f36d58eb20ca6e0b939688b06e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bceccaf5d47ad835bc0dcda3dae6fc0fff5ad1b340ac8299cc2198a22664347b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea183f040608b52ad5addeccad9e4c79095d68d531e6e9a71d1c0017ba0e992d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50f6dae3cfb4a0ac6bc61480814e8ff7b5aded5f3ecaf9a6a09c8dea47b033be"
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