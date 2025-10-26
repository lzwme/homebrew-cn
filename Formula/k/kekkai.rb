class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://ghfast.top/https://github.com/catatsuy/kekkai/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "9b0b455f747fabd1b8b8d90abaa438e9998ff4171e6e8b39d965ffef4a8d54f1"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e9c740b08ae0d0e541a991ab622fc4d2d5c5d8dd428ddc76e295a8fbdebd5d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e9c740b08ae0d0e541a991ab622fc4d2d5c5d8dd428ddc76e295a8fbdebd5d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e9c740b08ae0d0e541a991ab622fc4d2d5c5d8dd428ddc76e295a8fbdebd5d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a69b2bced21476f08e6252431d6eb68a0773fbafd7445e6e1f7fcc56be1fa90f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b229bfc01a0448f6292005890903aafc7d7896271fce7ef3a24f98665cbd13cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3792b8b3d96095c514364a77b4bab907ebf8a5051b2325742697607a530902fa"
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