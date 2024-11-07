class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https:tanka.dev"
  url "https:github.comgrafanatanka.git",
      tag:      "v0.29.0",
      revision: "b44bdc9a210e4b9c734afa89e9a049c4112576ae"
  license "Apache-2.0"
  head "https:github.comgrafanatanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e03063feba293dc9e5051d27e0784f1f458fcd695479e5a8793d4ce24ca3e09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e03063feba293dc9e5051d27e0784f1f458fcd695479e5a8793d4ce24ca3e09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e03063feba293dc9e5051d27e0784f1f458fcd695479e5a8793d4ce24ca3e09"
    sha256 cellar: :any_skip_relocation, sonoma:        "8883266f9e1b8f760896bd165a85b9527494fecabec9ed75cd39f935105da752"
    sha256 cellar: :any_skip_relocation, ventura:       "8883266f9e1b8f760896bd165a85b9527494fecabec9ed75cd39f935105da752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f64b687b36d2554eedc0465aaa58e27647eefcf255469a979dff8aff4ea6f4c1"
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