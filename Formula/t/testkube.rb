class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.68.tar.gz"
  sha256 "c723972af23b3138e3ad2b55a94de7b7d33f645f13b23c514d1a428e6a851a9b"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef5acad4d8004316fab8813ddfc325ee26dcddd66b48c735476210044bf375e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef5acad4d8004316fab8813ddfc325ee26dcddd66b48c735476210044bf375e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef5acad4d8004316fab8813ddfc325ee26dcddd66b48c735476210044bf375e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bc0845533cda14f01b5308891b7e8e41116017d8c3499594a5bcd1c1f91f979"
    sha256 cellar: :any_skip_relocation, ventura:       "2bc0845533cda14f01b5308891b7e8e41116017d8c3499594a5bcd1c1f91f979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83a90158cc9c24ae99b2675d4cd63ccd10668b3eac87e0ebf6e2572a42f24a23"
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