class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://ghfast.top/https://github.com/grafana/tanka/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "3f8b3afb2c3a2ba9d0ae4efac47f658a87dda817a3fbaba615eb07b9dfd4c02f"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db34907ae776731eb5c04569e1d0467fc84df3904bdd2649d6a5a71c866c7b74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db34907ae776731eb5c04569e1d0467fc84df3904bdd2649d6a5a71c866c7b74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db34907ae776731eb5c04569e1d0467fc84df3904bdd2649d6a5a71c866c7b74"
    sha256 cellar: :any_skip_relocation, sonoma:        "06e60af208f678fc0b3b39ee1c9d9354824ac0cca8ad6a5d4156cf50687da603"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93a1e242ff13539fefed62cfa58c51b2af44a12abc4e0aae64db11fd04651454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35a26a78f3e2fde176f643541ebe0b2d2f5cc4dd5408f37fa99e78c0dbaf8425"
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