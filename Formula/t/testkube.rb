class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.40.tar.gz"
  sha256 "0f69892b72ac8600f0b5301ae5f6da6c8e5fa16e47a4a4d57be2060647825416"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02442519b772a88bce1dfa4829eb367755f324f3ebe01d520406a0a48213263b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d726b709a0fc9cb17281d914868bfbcd237e5edaaf5115e3ef96f644d85e906d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8900a35dcfb4731a12846faf1f091986e3c314eea4e7f0e76d98fd654abf2f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9947e640cbdb7b995d513d8c498d92fea8f1d64fb7ca80314ce78157674a8aa8"
    sha256 cellar: :any_skip_relocation, ventura:        "07ff025ca1fd24babf574764847fb4bc962eb7a27ef7ee219af52b7d7f2d2ace"
    sha256 cellar: :any_skip_relocation, monterey:       "f366ce690c19021d63d37b64d4483be34f5cac91271938911ccccd8342387a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd630b6c39bcf896143c3843941bdad21bc053ef175aabf5148410414daa675e"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags:),
      "cmdkubectl-testkubemain.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end