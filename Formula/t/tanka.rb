class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://ghfast.top/https://github.com/grafana/tanka/archive/refs/tags/v0.39.2.tar.gz"
  sha256 "2f41cb90ed8b20e8729d58b0468b3be938bdb40d723d96e47314114573eccbef"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97ad0faf6c7d1cec51b5afe84b468bb661c39783f90870bf465988a96d2ccb74"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "97ad0faf6c7d1cec51b5afe84b468bb661c39783f90870bf465988a96d2ccb74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97ad0faf6c7d1cec51b5afe84b468bb661c39783f90870bf465988a96d2ccb74"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0d6bebf1bd034371976456cbe4f8e4bb3dbca4371f7703f11f2c5ae6b4790378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2679625e4f32a3e1324f89b4f9243541bc1f91972809e39538309e854c287b56"
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