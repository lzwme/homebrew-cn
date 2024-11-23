class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https:tanka.dev"
  url "https:github.comgrafanatanka.git",
      tag:      "v0.30.0",
      revision: "d712789d786f6d3892db26af549c37add4d05223"
  license "Apache-2.0"
  head "https:github.comgrafanatanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15bf18ad260cf49752a971819d94ddebe106b6d1443faf3206344b3e2be717f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15bf18ad260cf49752a971819d94ddebe106b6d1443faf3206344b3e2be717f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15bf18ad260cf49752a971819d94ddebe106b6d1443faf3206344b3e2be717f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea47c62501ae4e8eca354538f205440aaefa15a00100312c6a43968797de617c"
    sha256 cellar: :any_skip_relocation, ventura:       "ea47c62501ae4e8eca354538f205440aaefa15a00100312c6a43968797de617c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cdaff59b53f0c7529dcc532933b17c8bdfbac3d6283b5d965d1748c1156fc5a"
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