class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://ghfast.top/https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "fc9c6e5845b198b465483014ef8b089f6f434ca570e7b72b3fb82e75972c68c7"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9aacf8a7f5fc216ff717d0fc9953d63420337020842dea6ef8a817ab7ee02edb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9aacf8a7f5fc216ff717d0fc9953d63420337020842dea6ef8a817ab7ee02edb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9aacf8a7f5fc216ff717d0fc9953d63420337020842dea6ef8a817ab7ee02edb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3667107130ca94760e01717344df5012b216a4abd7f2a25d6f57230510a60be0"
    sha256 cellar: :any,                 x86_64_linux:      "d4cd126a364848774d8578fd5b475c1ef0ec10329410333177d1e77a1dfabf99"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/catatsuy/kekkai/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kekkai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kekkai version")

    system bin/"kekkai", "generate", "--output", "kekkai-manifest.json"
    assert_match "files", (testpath/"kekkai-manifest.json").read
  end
end