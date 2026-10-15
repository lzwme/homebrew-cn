class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://ghfast.top/https://github.com/kubecfg/kubecfg/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "367e06009a58a32e8c1be81f4b8433ad104d3fab23b835fe61e80ac3b1d99455"
  license "Apache-2.0"
  head "https://github.com/kubecfg/kubecfg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "142de32003016f288bbca27260de909cdf3128e7c6868b442fe968b199750aed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0a9e31eb35426a55a8dbb55e409ec2d9a104e3e9f7b2d3082255429b9386f9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "142ba685de200f242e8fd2d9bb403634997b22ed72a3d2c79d1848af64e0a6e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "254d48b56afb55bf03e7ebc0de01bb0be545ec1ef7119365dd5afc2f37b361a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "22f356ceeb6e0bd46d5e4128ff19ad3f87155440b9059b144b364a6231050347"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "VERSION=v#{version}"
    bin.install "kubecfg"
    pkgshare.install Pathname("examples").children
    pkgshare.install Pathname("testdata").children

    generate_completions_from_executable(bin/"kubecfg", "completion", "--shell")
  end

  test do
    system bin/"kubecfg", "show", "--alpha", pkgshare/"kubecfg_test.jsonnet"
  end
end