class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.5.5.tar.gz"
  sha256 "53838182c26c578e3b4e2ce3d6b930ec55b02f316d76c84e39f38c060e4f2b7d"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "947a6aa247b543f2304f02052e8e0c1b8383a402345fe933ed050fac042891c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acc92e674463bfed8f226f7471bbff9e5631e291db5c8f0f441fdfb39f00a4bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c9c6b601bdf268d5de6416aac0a86ad40f53dba78b1c9f28191ba01f93339e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cfd65dc311ce5558d08dce46fe92ad916d0b64edd221ac88b0a2af28346709d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71ae45b533070b893ed62afdf32c8842e1ca627370d866b4c2cc4e1f4e9bb1a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a19c1a3b07aeb8d59ca39f699e11b53b7edf78310901eedaa82cf70a80d2c00d"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end