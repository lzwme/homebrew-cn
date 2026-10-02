class GitPkgsProxy < Formula
  desc "Lightweight caching proxy for package registries"
  homepage "https://github.com/git-pkgs/proxy"
  url "https://ghfast.top/https://github.com/git-pkgs/proxy/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "1902ea0ff1b38546dcd46cf56f5ebef1bf113d5037f973df649d16761a3ec241"
  license "GPL-3.0-or-later"
  head "https://github.com/git-pkgs/proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3dd8ee6959932dd50c98a879482e136a87ae31e6750d08cea41365cdc11d20ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "058a290c9f46cc0acdf68623ecec3898fe60288d2f0f2530d6d3d512cdab513a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5aefc8bba7add679df7c77edb6c4731c1230d75f62759666419f594bda82433c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "712d7f228af3cebb15fc54d7b1979f3a798a9cd5a240425c7a95e41efd1755da"
    sha256 cellar: :any,                 x86_64_linux:      "bdb0254036a9bab6b5fc715f4a494fbcf8f3f68bd4f32691ec825da3ded8055a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"proxy"), "./cmd/proxy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxy -version")

    output = shell_output("#{bin}/proxy stats 2>&1", 1)
    assert_match "database not found: ./cache/proxy.db", output
  end
end