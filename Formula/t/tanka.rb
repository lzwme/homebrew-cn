class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://ghfast.top/https://github.com/grafana/tanka/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "284b15875e3f2979fc94f2950f8c6eadf62cc8c1177921fb546f3a6bf506a7fe"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35ba246c8bfd19b534a5f4cbed0de147e661f189fab57523bf5cb28b1bd8d0ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35ba246c8bfd19b534a5f4cbed0de147e661f189fab57523bf5cb28b1bd8d0ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35ba246c8bfd19b534a5f4cbed0de147e661f189fab57523bf5cb28b1bd8d0ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "e420e8399caf38a8bc7fbb06fa5a98c080f538525383150aa9fc14f158340cbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "936a3372b9d411e35ad8f6d4957ce03f71689bbc606ceb52fbdd0ab0084c04b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13689901cbe0fcb5f4e20e1d94bf3311302b3c8295501330579a03073193e674"
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