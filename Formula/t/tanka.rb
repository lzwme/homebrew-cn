class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https:tanka.dev"
  url "https:github.comgrafanatanka.git",
      tag:      "v0.28.1",
      revision: "f0b1082d7712239b0855e8c50265d35582c1878a"
  license "Apache-2.0"
  head "https:github.comgrafanatanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2beb1fed8e92500ae648d9c2c4ed39f7810e6e14ca19620bb9b9dbeaf34972ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2beb1fed8e92500ae648d9c2c4ed39f7810e6e14ca19620bb9b9dbeaf34972ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2beb1fed8e92500ae648d9c2c4ed39f7810e6e14ca19620bb9b9dbeaf34972ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "728c1bdcc8d17e657fb2ad23426832b1a7c7b92e6f7a763f831775f1314c613a"
    sha256 cellar: :any_skip_relocation, ventura:        "728c1bdcc8d17e657fb2ad23426832b1a7c7b92e6f7a763f831775f1314c613a"
    sha256 cellar: :any_skip_relocation, monterey:       "728c1bdcc8d17e657fb2ad23426832b1a7c7b92e6f7a763f831775f1314c613a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b61c71bfda2da0f477213ffb648e6fc1baa8265007baabd1f7a5ca673db4314e"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.comgrafanatankapkgtanka.CurrentVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"tk"), ".cmdtk"
  end

  test do
    system "git", "clone", "https:github.comsh0rezgrafana.libsonnet"
    system bin"tk", "show", "--dangerous-allow-redirect", "grafana.libsonnetenvironmentsdefault"
  end
end