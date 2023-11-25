class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.8.tar.gz"
  sha256 "ef471e52a7bd4139f0b2a350105e044c4747370b02a1d6d2bb7a7c85c049da8f"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "983207c481aff98241d90884eb2545fa4ac4f3ac4043a2619b17aa6c19ea22f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e14ec2d186076a01e604f9cc0c64eee3d91a98254b89b8bd74c28c40d26584cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94011de3e786808e09230fc2e878206549f49e0bfd64db7a71170eba62c6eb55"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e9be8f0d86c6b885a1f8a018c70f97ca37ebc54d3dbc4f347416b89d7f93979"
    sha256 cellar: :any_skip_relocation, ventura:        "557afaedad56156935f7dd2ded48ae213d4f6da6847d0d72f3bb5413ba2dc2cd"
    sha256 cellar: :any_skip_relocation, monterey:       "fd1a3a47817b8d57fb3504d5bf4738e27e9c55a2ac43733233ac56b1cd32d286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d504ab9e4f088bc9f1e5b20e6dd4a910979ad5b00f6318af60f136b1e476a37c"
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

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

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