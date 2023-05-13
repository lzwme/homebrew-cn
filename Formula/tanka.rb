class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.25.0",
      revision: "ac7f3e9b1f844940af9360eefb20f1005cd6bec4"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27dc70150541299dfbe928daedbdee2df708940dba0ea089ddea17b2209eb410"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27dc70150541299dfbe928daedbdee2df708940dba0ea089ddea17b2209eb410"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27dc70150541299dfbe928daedbdee2df708940dba0ea089ddea17b2209eb410"
    sha256 cellar: :any_skip_relocation, ventura:        "56c8ca7bc4fd650ce5cee43820990e867486d77b3948635db3956ae49523675c"
    sha256 cellar: :any_skip_relocation, monterey:       "56c8ca7bc4fd650ce5cee43820990e867486d77b3948635db3956ae49523675c"
    sha256 cellar: :any_skip_relocation, big_sur:        "56c8ca7bc4fd650ce5cee43820990e867486d77b3948635db3956ae49523675c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd0d630538ea680ca271f79e9f146ae262498bbc9647bc14ea719029331b10e"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/grafana/tanka/pkg/tanka.CURRENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"tk"), "./cmd/tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system "#{bin}/tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end