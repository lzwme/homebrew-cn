class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.36.tar.gz"
  sha256 "143a3306ffd8efbc32b9cfe16359f42813a80d072ac84a500a5d94e2dc76e01e"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d8fb8ead822651e59016ad919179337b9a5d9a2fbd6b8bea515dee41b165397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d8fb8ead822651e59016ad919179337b9a5d9a2fbd6b8bea515dee41b165397"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d8fb8ead822651e59016ad919179337b9a5d9a2fbd6b8bea515dee41b165397"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7c8a7cf7a57647c305ee5c52468a54bf78cf1bc76dd95ddd47f059fc3dfd8bf"
    sha256 cellar: :any_skip_relocation, ventura:       "e7c8a7cf7a57647c305ee5c52468a54bf78cf1bc76dd95ddd47f059fc3dfd8bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1d293e129734f820f76e50436437bb9b9f2a1ab8c7fbf6528c611221e0c529b"
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