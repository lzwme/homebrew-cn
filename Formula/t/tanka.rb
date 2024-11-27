class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https:tanka.dev"
  url "https:github.comgrafanatanka.git",
      tag:      "v0.30.1",
      revision: "bae4edb653b26da962ad05c5f124cc0f5443a8ec"
  license "Apache-2.0"
  head "https:github.comgrafanatanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "289d471abb639e0a2f0749760076c0a95be064baad8b27a2380efab75ab1dd5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "289d471abb639e0a2f0749760076c0a95be064baad8b27a2380efab75ab1dd5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "289d471abb639e0a2f0749760076c0a95be064baad8b27a2380efab75ab1dd5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5744a7ebfc3e8b4e12200010d5a1b1bf929edcb640f4b654daee54ded9908a5"
    sha256 cellar: :any_skip_relocation, ventura:       "d5744a7ebfc3e8b4e12200010d5a1b1bf929edcb640f4b654daee54ded9908a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "825c8dbd13cbc17477ffbc04c3feb51e1eadbfec093c14b66d828aca8c7ca29e"
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