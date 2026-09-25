class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://ghfast.top/https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "9658ef158acdd544325063e4b44528b494a064144c8353690cf0420d8996112a"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aa532e386c23539c0c36fb5c165cb0bdc90d1f9ddfa4596b04147215947d43df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "012fb85cd766c228cddc255e4fd2edf3795570d8b9d2017aeebbe60e5cc5e7fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b4cd61c0b6e35d1bfd43c4f8e10b1ddae8eef4452d98ce337375bd0f84157464"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e094d4b8fcb6a3245774d46b16637b765b52e750290e70a6ea6fe5e69df1df2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7c99e78b6f1a904e80868099f42452fa5345afc7806b4e0e4e8b157ed7b70468"
  end

  depends_on "zig" => :build

  conflicts_with "fx", because: "both install an `fx` binary"

  deny_network_access!

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fx --version")

    output = shell_output("#{bin}/fx ask hello 2>&1", 1)
    assert_match "fx needs access to Vercel AI Gateway", output
  end
end