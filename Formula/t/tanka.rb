class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https:tanka.dev"
  url "https:github.comgrafanatanka.git",
      tag:      "v0.28.3",
      revision: "c5180bff80493da1586fc0d05117a5cfde5effa0"
  license "Apache-2.0"
  head "https:github.comgrafanatanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68ffdc1b31a27c8ce5292b4169af654ab399be75c5d4e45ce8cc5d4d142d924f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68ffdc1b31a27c8ce5292b4169af654ab399be75c5d4e45ce8cc5d4d142d924f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68ffdc1b31a27c8ce5292b4169af654ab399be75c5d4e45ce8cc5d4d142d924f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c97c2886c818fed631d4f123480cbe76194f3a4ed759e07cdb737b844a6e51e"
    sha256 cellar: :any_skip_relocation, ventura:       "6c97c2886c818fed631d4f123480cbe76194f3a4ed759e07cdb737b844a6e51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6998e45dff8b8d559ac054e5450c1a2db694a10e1079ffc589576b80f5d908ce"
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