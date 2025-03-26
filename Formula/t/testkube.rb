class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.124.tar.gz"
  sha256 "01c1afc1893be4504d6acf011a8e5508a600b8cbb6a4e0ffee6ebb1849ca353c"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02dca89cb737f61beabb9feba0aabf0166a0a118325e3216c071d42bb95dac9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02dca89cb737f61beabb9feba0aabf0166a0a118325e3216c071d42bb95dac9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02dca89cb737f61beabb9feba0aabf0166a0a118325e3216c071d42bb95dac9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "60a4dd1c939351bb960e1867cd9f6ec94b0eed4cff8c46ad48deb9bf36819c7a"
    sha256 cellar: :any_skip_relocation, ventura:       "60a4dd1c939351bb960e1867cd9f6ec94b0eed4cff8c46ad48deb9bf36819c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "037dadb36bf7c8cc8c773f44cccb73c7915e863577a389e78bd2328bb9d965d8"
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