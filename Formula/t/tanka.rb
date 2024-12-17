class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https:tanka.dev"
  url "https:github.comgrafanatanka.git",
      tag:      "v0.31.0",
      revision: "d79a53e056495892fc202d2123a698ecb5e8ecb7"
  license "Apache-2.0"
  head "https:github.comgrafanatanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2312c83ae68e7f566dd9c88fe8fde8f61d93d9dd048a6bd8f09db6e1bbb53c6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2312c83ae68e7f566dd9c88fe8fde8f61d93d9dd048a6bd8f09db6e1bbb53c6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2312c83ae68e7f566dd9c88fe8fde8f61d93d9dd048a6bd8f09db6e1bbb53c6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e933ac02a61aa6f43af8e7837ebd442f8c57543b7960470e6440c777e4a41821"
    sha256 cellar: :any_skip_relocation, ventura:       "e933ac02a61aa6f43af8e7837ebd442f8c57543b7960470e6440c777e4a41821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f623b0738da74a59e3db2037f89643ba9612adbfd30085d87e7a49cd57faa67"
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