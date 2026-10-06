class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://ghfast.top/https://github.com/grafana/tanka/archive/refs/tags/v0.39.3.tar.gz"
  sha256 "c2b7aa0f0e9f63d155bca14b0cf78b8fc53eea7083c5babc73f8922a45ff3bae"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53760507a7aaaedb5f2d5a3296755c35b8cd5b7a8795d9951eccfcb494429d58"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "53760507a7aaaedb5f2d5a3296755c35b8cd5b7a8795d9951eccfcb494429d58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "53760507a7aaaedb5f2d5a3296755c35b8cd5b7a8795d9951eccfcb494429d58"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6b181c50d1b0da3cc399d8a697fa75536d09d3e4c393c94b5a61c277a730fd37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d295f57954098fcc3c68dea1cdb40877634ef2ebf60c66ff01564f10fc33df78"
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