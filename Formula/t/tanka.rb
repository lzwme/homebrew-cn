class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://ghfast.top/https://github.com/grafana/tanka/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "d4a30e0baa15a4890403263eef7ff6addd59a969a66e9829d101ac200849cff5"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7f017a7510f6c530e5d668e0aeee9bd922fad81331fae29d483b09b0913c1d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7f017a7510f6c530e5d668e0aeee9bd922fad81331fae29d483b09b0913c1d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7f017a7510f6c530e5d668e0aeee9bd922fad81331fae29d483b09b0913c1d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3ee99fa558a7e294e060251479e9c3489023cd19c461cf6bfbd2e5651469dbe"
    sha256 cellar: :any_skip_relocation, ventura:       "c3ee99fa558a7e294e060251479e9c3489023cd19c461cf6bfbd2e5651469dbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f3b1b71219e74154404e91925a9a59c2d333d23018f35532cf40cea33be10df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6e110fe09fb3e67a4fc3d6d0c27be4ffa00f7226ef2e9be818738a585beac19"
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