class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.137.tar.gz"
  sha256 "9bfd57fdcb99ac2bc8595077d8c1d59b683f83533b04d8b41290c3d93d7d1ca9"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d51c1df372a609678cd094d8080738624380d9f9ecedce8201165d8fa446073"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d51c1df372a609678cd094d8080738624380d9f9ecedce8201165d8fa446073"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d51c1df372a609678cd094d8080738624380d9f9ecedce8201165d8fa446073"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b5a2306936e28ee9ced6d969057f7109dccc5afbb515f97d16500fbdf6c916e"
    sha256 cellar: :any_skip_relocation, ventura:       "5b5a2306936e28ee9ced6d969057f7109dccc5afbb515f97d16500fbdf6c916e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c33b453bff510626cbd3e814676bf4336610db803a63f68f40907ef33511f525"
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