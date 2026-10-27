class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://ghfast.top/https://github.com/grafana/tanka/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "7fcd8c7cd642e08b39f9218c980370e1390837db05ef5f5eb39328830841927d"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da272682db2327b62c88df71c08ec46a2113c7ba692fee57998f6af2874e4584"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da272682db2327b62c88df71c08ec46a2113c7ba692fee57998f6af2874e4584"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da272682db2327b62c88df71c08ec46a2113c7ba692fee57998f6af2874e4584"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "53bf10dbd48a15b0633cb027e8b60c6f82e718dacacc0964131b9370e78c2c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "92e3947ee4e20d2f29ba982d0c64c691b2259f588241f4bdd16f75654375bf80"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[-X github.com/grafana/tanka/pkg/tanka.CurrentVersion=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"tk"), "./cmd/tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system bin/"tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end