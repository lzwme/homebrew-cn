class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https:argoproj.io"
  url "https:github.comargoprojargo-workflows.git",
      tag:      "v3.5.3",
      revision: "0fdf74511d4671cf0c8c334aa2d90ecd61c5acce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9998fc0efe68afba5a568d664c7e5590a37eeee3040c0515011e46fa3086f82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11c10a30115b034cc1ba0abbda24a7f2c2ddbadae02490d645801f7a1b72ed7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2cd03969c395d47fd6446597908918dc5da2adcd203c796089348955b5e6acb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f79f20bce6e3c9a9968bbc3ecd08697ff50aad0fcad23529455a5528a4901744"
    sha256 cellar: :any_skip_relocation, ventura:        "07ec35ef01091c6897cfdd3fcc9f65488ff0da07f66c5454a71109fa406e6f4b"
    sha256 cellar: :any_skip_relocation, monterey:       "490167dac5d6ab85546348461fa1ab8fccb0a7c96499f3b9d8801fb1cb50e510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75ff2ae9077e5fd041a8943e7e67a05d554bf29069f2ac8677aca19a91abec28"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "distargo"
    bin.install "distargo"

    generate_completions_from_executable(bin"argo", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argo: v#{version}", shell_output("#{bin}argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}argo lint --kubeconfig .kubeconfig .kubeconfig 2>&1", 1)
  end
end