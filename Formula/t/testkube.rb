class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.32.tar.gz"
  sha256 "a3ac6884e1516cd6baef56af45f423b8ec3eee4fbf6c4c222658ec668e9fe716"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a02f13f4ddf610ae93a624a6d060c330b9cabea880400111a75b0f6eed657f16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a02f13f4ddf610ae93a624a6d060c330b9cabea880400111a75b0f6eed657f16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a02f13f4ddf610ae93a624a6d060c330b9cabea880400111a75b0f6eed657f16"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc0a44a6a5b3320d5b98bd577c85d1b468c11811cafd6f8e306411c8a468cdc3"
    sha256 cellar: :any_skip_relocation, ventura:       "dc0a44a6a5b3320d5b98bd577c85d1b468c11811cafd6f8e306411c8a468cdc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ce25d36e7cf1026a7253209aaca4a530e205c0ad860c9be52f477b7143e6d6b"
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