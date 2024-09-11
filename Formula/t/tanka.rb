class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https:tanka.dev"
  url "https:github.comgrafanatanka.git",
      tag:      "v0.28.2",
      revision: "b9c7d9f12b3a85b5bd1e788a8fb7be9787af91af"
  license "Apache-2.0"
  head "https:github.comgrafanatanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "aa3674fd0f36d6c6601167a3219dd428dafc960033fac2ae5ef8a8f9e955ab70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa3674fd0f36d6c6601167a3219dd428dafc960033fac2ae5ef8a8f9e955ab70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa3674fd0f36d6c6601167a3219dd428dafc960033fac2ae5ef8a8f9e955ab70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa3674fd0f36d6c6601167a3219dd428dafc960033fac2ae5ef8a8f9e955ab70"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f571eb9ed4577d690eb30797c7ce6a2befb422b69d3e7e94344203dd76792c1"
    sha256 cellar: :any_skip_relocation, ventura:        "7f571eb9ed4577d690eb30797c7ce6a2befb422b69d3e7e94344203dd76792c1"
    sha256 cellar: :any_skip_relocation, monterey:       "7f571eb9ed4577d690eb30797c7ce6a2befb422b69d3e7e94344203dd76792c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac030e886e01c43c867e1c05e4f713f04102ab6a6227b37a25cfe39733cb3314"
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