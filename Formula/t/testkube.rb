class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.82.tar.gz"
  sha256 "0f4d1dab41a78905a31f0681466bea45a0715e9d74bfecff5787bd70d8941ee6"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ae1f0c650ddc44b79bb2dbf13bc8e1a25709a7dfad99814808c91314d0c792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2ae1f0c650ddc44b79bb2dbf13bc8e1a25709a7dfad99814808c91314d0c792"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2ae1f0c650ddc44b79bb2dbf13bc8e1a25709a7dfad99814808c91314d0c792"
    sha256 cellar: :any_skip_relocation, sonoma:        "f92b1cdad6cab9b192b13e8e3b6454d210edef2cb3a59c7c4e16d31379fbf927"
    sha256 cellar: :any_skip_relocation, ventura:       "f92b1cdad6cab9b192b13e8e3b6454d210edef2cb3a59c7c4e16d31379fbf927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "363fa6aeb0edcba07d42f465d2a5f4edff888893422d444818fe64391b7ce8a8"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion", base_name: "kubectl-testkube")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end