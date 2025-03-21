class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.119.tar.gz"
  sha256 "08300c37157f1e4edd2ebea751fbba610fa5e98eacf7b772b465fd210ff46152"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35ea0e11ac6674d7e9e7cec9f9449096dd87a9a1836ef5ef6133b686c9718a33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35ea0e11ac6674d7e9e7cec9f9449096dd87a9a1836ef5ef6133b686c9718a33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35ea0e11ac6674d7e9e7cec9f9449096dd87a9a1836ef5ef6133b686c9718a33"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ac940aba56b56903ae359a1f51676fcddd599b8fa2b28c2c65f002faea0ed31"
    sha256 cellar: :any_skip_relocation, ventura:       "9ac940aba56b56903ae359a1f51676fcddd599b8fa2b28c2c65f002faea0ed31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4c7bfae79af81750aea19cfca221e4c8cdef935047e6ebdb25483ea007a886d"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
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