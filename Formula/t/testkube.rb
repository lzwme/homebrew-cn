class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.109.tar.gz"
  sha256 "6f67d1f602f1121c6181863fdb319eb33be8c431e5ddfc5a5c474c52d204b6c7"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35611a032259d28382ce94a57d6b92d5fb468a1a5410205f9a934bccc3451ce5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35611a032259d28382ce94a57d6b92d5fb468a1a5410205f9a934bccc3451ce5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35611a032259d28382ce94a57d6b92d5fb468a1a5410205f9a934bccc3451ce5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe1b2a1dbed2c8032c742f113b4073065dbcf076633816572817f2d4055ec125"
    sha256 cellar: :any_skip_relocation, ventura:       "fe1b2a1dbed2c8032c742f113b4073065dbcf076633816572817f2d4055ec125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "006903abd4d797d7db8b8571ad2cd4a80c9baa454e4f2e88cdf3135b43ee4842"
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