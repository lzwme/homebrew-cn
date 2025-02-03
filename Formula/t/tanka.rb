class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https:tanka.dev"
  url "https:github.comgrafanatankaarchiverefstagsv0.31.2.tar.gz"
  sha256 "82ae2a379313c25d60f4a44a55af35de065c85e249b4e9c936f1173fca0a5908"
  license "Apache-2.0"
  head "https:github.comgrafanatanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d54baac79128b9d9a49ee4c50e32e64e68b8703a3822c5630f75f1e721a30d1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d54baac79128b9d9a49ee4c50e32e64e68b8703a3822c5630f75f1e721a30d1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d54baac79128b9d9a49ee4c50e32e64e68b8703a3822c5630f75f1e721a30d1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "afab90f615ba32ae74b4c75c0e9c381f762177e9922dad3f805a7de4d4321808"
    sha256 cellar: :any_skip_relocation, ventura:       "afab90f615ba32ae74b4c75c0e9c381f762177e9922dad3f805a7de4d4321808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9076896004af6516b143d467ba7538095319c43b9ee794d0e6d53e7c2eee14c"
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