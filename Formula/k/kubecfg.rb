class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://ghfast.top/https://github.com/kubecfg/kubecfg/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "71e0f6ad576581f203a25e332c47320a5271199efbc0d614b78c79aaf6f30c76"
  license "Apache-2.0"
  head "https://github.com/kubecfg/kubecfg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e1f051e8074ed32546e20c7152cbf5a5c2b3465ac1449c59a5da8cb6298664f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c220a996635b869f09cea968caf84070b909d1f8ad5d430a31816a69d1cc7139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e975cdd1d6c824817ee71810ab0ae42f703eee4f14a7f6fe4122c62d52d8a05"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aeb2954da95e5ef6e838ae7c4177b915615b4514603be05414c60c9130254a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1540135185bebd982adce6f98f9c033a8724ae7ab5cdfbb1d7b13e95280d0793"
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