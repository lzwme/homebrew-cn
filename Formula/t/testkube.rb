class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.8.tar.gz"
  sha256 "0e161dd7fc7a425cd7872c4b03b8898cf6cd07c8f2aae3c49bf20db5f08575ea"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d331b61a110793d363e69a1711a4354213ed3c9662d7b70b59babf41ff72419"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4219040d5578051fd4fab8b394f644a85e59c337cec8dd43346192694529f016"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9390ea61d7c7ce0a109cb6a2476e82588e7ccdf928506d34bb6a3befd1fe93ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc085bf1786b37a7e319f5ab52ad07d5b0adf47fea3bba88eaae07481f8a5d3a"
    sha256 cellar: :any_skip_relocation, ventura:        "9c00b393136b3ee12f9f1693a4fcfa6f73a490576b56729fe7dbab7da258be59"
    sha256 cellar: :any_skip_relocation, monterey:       "92f319a5746a0f8683685cd5abdf108b1b0445a19d50a53171185257fb28aa03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9b5846e45423f9562f8fa77d987be431e94bbdf5c934a88ac2e7d65d0ad3056"
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