class GitPkgsProxy < Formula
  desc "Lightweight caching proxy for package registries"
  homepage "https://github.com/git-pkgs/proxy"
  url "https://ghfast.top/https://github.com/git-pkgs/proxy/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "7a470a221374a8ee2ea25f38ef6068096fd674fd46221bafc2ae7dbf948f7616"
  license "GPL-3.0-or-later"
  head "https://github.com/git-pkgs/proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "46cb5fd118e0b0087cfece9db4af899f24762d81957c505983c9e2c5b0573b65"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0dc27086edada461c5388754be4d1ee6300f92eff3a9b5c87bd6d631ec1f0b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e10d09b39fcd7c1c168623a43a0b9768b2d63236c72f1bff1e15f76e70980e6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a26ca577b28beedfcec54daeec9bef161da1e283e75a0a47feed8420165e84f7"
    sha256 cellar: :any,                 x86_64_linux:      "0087edbf225d168965081a1b170f498060c0df6be36d39e9153a652d1e8e7f2a"
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