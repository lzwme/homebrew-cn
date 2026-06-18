class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://ghfast.top/https://github.com/grafana/tanka/archive/refs/tags/v0.37.3.tar.gz"
  sha256 "ef2a0d390097fee64cd1e37b11f886b7abd4634a2b5ae90618449ee38ddba2d0"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83cc238fd19cfa147aa4d94a6800d9addba48d723ad588325b44abf186252201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83cc238fd19cfa147aa4d94a6800d9addba48d723ad588325b44abf186252201"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83cc238fd19cfa147aa4d94a6800d9addba48d723ad588325b44abf186252201"
    sha256 cellar: :any_skip_relocation, sonoma:        "9df30b20e1a287b72dcfffa211a27d626ec4044fe0cde80e26b337ec5bbdda7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "167a7c6831ab961d18c8da482b5cd108848aef0b1bf2252a843c738d647ed6e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25ec038ab5e8a0ef876cf5f6f589fb01ddfdc771a746c97d9e61d4f4fd912477"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/grafana/tanka/pkg/tanka.CurrentVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"tk"), "./cmd/tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system bin/"tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end