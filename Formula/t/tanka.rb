class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://ghfast.top/https://github.com/grafana/tanka/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "74b4214594597a46dcf563c53a7944e737c7e7ed1ae6c7b69521ff4676e886af"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0429c8c19c27ff02d3b4c31ac304bd8040b6e46655bc8068f8731006b8e53fe1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0429c8c19c27ff02d3b4c31ac304bd8040b6e46655bc8068f8731006b8e53fe1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0429c8c19c27ff02d3b4c31ac304bd8040b6e46655bc8068f8731006b8e53fe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "11fb3642ce95882d18e5e1547a0fd3ac2580b92db4c7e349b6a5c4593dd8d54f"
    sha256 cellar: :any_skip_relocation, ventura:       "11fb3642ce95882d18e5e1547a0fd3ac2580b92db4c7e349b6a5c4593dd8d54f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2633e51428aea5d139e847126e0a571711f3e0cb2ed8b4c08e1af2b215420c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2da2f79cdbf20090ca11999f373c62d347b792d7fbaa96c73d743c2b17c135cf"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/grafana/tanka/pkg/tanka.CurrentVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"tk"), "./cmd/tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system bin/"tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end