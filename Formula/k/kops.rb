class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https:kops.sigs.k8s.io"
  url "https:github.comkuberneteskopsarchiverefstagsv1.29.2.tar.gz"
  sha256 "0e3d5e367cd7ced41a8499ec45c3d90fa2c3852f758aa737d8f925089f702e77"
  license "Apache-2.0"
  head "https:github.comkuberneteskops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1b0eb4b327e6b33c9d5a92906e1bcb090a1d752dc258552647bae4e6279347f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae469d12e679e72a8bdfbf23417975b1ea5d53b75c857c4965e1f105554454f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bdf24dd55dfbc01e0b9905b73bf21a4535dec39a57a66b9c2116f4597530af9"
    sha256 cellar: :any_skip_relocation, sonoma:         "db96ce563d1955cce9c1cadaf25fdc11e59b5ae065b4f53928556cadb98a61a0"
    sha256 cellar: :any_skip_relocation, ventura:        "ed1ae6d6a1db35c4e242b767890fc02b48f248aeb8e99a43d045d5694a644c88"
    sha256 cellar: :any_skip_relocation, monterey:       "c8a1cf19fe7c23b5c5ad4606b051f3ea7d099721fa157762153b262238e68e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "864f3cb6bf175210b0b19d3dc821aa8067f95fc1ff6c26a80e599277cc1e7bfd"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.iokops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "k8s.iokopscmdkops"

    generate_completions_from_executable(bin"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}kops validate cluster 2>&1", 1)
  end
end