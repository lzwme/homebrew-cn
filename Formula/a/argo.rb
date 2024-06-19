class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https:argoproj.io"
  url "https:github.comargoprojargo-workflows.git",
      tag:      "v3.5.8",
      revision: "3bb637c0261f8c08d4346175bb8b1024719a1f11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "161e1a36aae87b5b0b8f09ff979b783a41b91e890c04b6d6ac87ee683f99bd4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c51ccfc90856051fbdc9e706972ed97034d1c2c6dc1fa08902154d853aa442e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64b6e42542088be95dbdc2564622031603074486f50282abfd6252c3905ebeab"
    sha256 cellar: :any_skip_relocation, sonoma:         "9413608a421fb17ff883d8ef04ec6d23b31778c446b7b6ca71d9d76260a99fa5"
    sha256 cellar: :any_skip_relocation, ventura:        "f8c26281436a2dd01926f824e41311f9fee593c5f83bc3bef67dfa3f9efedfac"
    sha256 cellar: :any_skip_relocation, monterey:       "a134770ace7ab0692a0c05466d2dc605db6566771bf27fda486ebf5e2cfe99f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a60fe1fe8a880d41877e2616216d8066085286aa520863239e73767ad3c4c7e5"
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