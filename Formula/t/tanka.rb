class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https:tanka.dev"
  url "https:github.comgrafanatanka.git",
      tag:      "v0.31.1",
      revision: "c8869ec0245fff15aee68b2f732d074a8af9f63f"
  license "Apache-2.0"
  head "https:github.comgrafanatanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19ea9fa1d6b6c8bcc40d2a35bab8506760ed36fe3e84dd4423e8dd0360bc28bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19ea9fa1d6b6c8bcc40d2a35bab8506760ed36fe3e84dd4423e8dd0360bc28bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19ea9fa1d6b6c8bcc40d2a35bab8506760ed36fe3e84dd4423e8dd0360bc28bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0da4f076dcda5d116891a71f4c21ffd7b1a109905e7fe5d381a858a98b6aa538"
    sha256 cellar: :any_skip_relocation, ventura:       "0da4f076dcda5d116891a71f4c21ffd7b1a109905e7fe5d381a858a98b6aa538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a44aece6d989407c24200dbadfdfca2d86b78adbcdf0a489b80ee56f5d35a72e"
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