class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://ghfast.top/https://github.com/grafana/tanka/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "9cf01cae4bdf45a8bf6474418dbc6556adc8eff9a4608c593068190993649c90"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0298e625fc254eebcc6658c908b354cbdab803cf6fbea791fb1bf24b7c963c7a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "499f2cd3facfe8e4375d80c89686b163cb17841a6853349792b1c50cb5f5a21d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "499f2cd3facfe8e4375d80c89686b163cb17841a6853349792b1c50cb5f5a21d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "499f2cd3facfe8e4375d80c89686b163cb17841a6853349792b1c50cb5f5a21d"
    sha256 cellar: :any_skip_relocation, sonoma:            "e2e52abf7d02b92ccfd68383f72ea2256397231cd95335d3ea97cf0b3ab7edc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5daaa0d089b8c1d77f1fecbfe4e89b8854590f267418ceb68131b46422d1becd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2c9c5b6ee866fd9e6ec87266a405815f2a1d62741346fcb54b2bde01709bb580"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

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