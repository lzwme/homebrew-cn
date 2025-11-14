class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.4.1.tar.gz"
  sha256 "a230d6c0e0b5e84ea3c7a7609d25cf88a3c8b0cda0a616b60147e86ccee48548"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b58e2caca5ed99605b9349e192f04c0e01cd7949c6595079eafa785663f1423"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df797e47e7cc57a60b322db9bccb9514b2eff4f0f17e531c4b82296adb65bbc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "258c0813cbe52e5634c9b2a850bf0c2dcfc6e392e84f3316a99f4f2fa1fd63e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f41fd18a7145fd9b3ec2e7515715a3f37bc911d2bf28f48e006c5df18a40a95b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ab63b2479bbc96d263f7d7bca06623fbc552a8a4a0ebf9c365ac2e0b38cced6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b163e7fc8e434505141f275b7577b6e4940ade495c0e32f7ce9977896093660"
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