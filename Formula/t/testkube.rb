class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.4.0.tar.gz"
  sha256 "9071609e51bebd3cb028e89bffcfbc7a90aef4541030163b413f57f92e49ae1c"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe42514d58c866c7129237d0c701a222a40073b0d9b1f845a4419a5975dabacb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "810863fbe8dc1b06280df208045c18681b41808d0102f9697db39126e7744f1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64b01198f3049632289e1b956fbf99a3e99226d470039f4fbdbc56aa504d861e"
    sha256 cellar: :any_skip_relocation, sonoma:        "711465ffaa278fbe1b3f7598a5ebcfbe3d840b1bdefda1189df9ff33d190dca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "278131aa64098950e166608da28feaba3398e7b24c1bf974bce5bfdfec80a057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c37aa1a042b556772db7b783f494d52a6c2193e81bb614f7075fbf0cb9b675a3"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end