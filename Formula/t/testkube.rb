class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.20.tar.gz"
  sha256 "ee96b32cc12f9b58594a6b18b42a353f5a515809b7c591da84f686a7e5e50aa6"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bbae79c68b94513e3f510817c4a3bbfeb7690c8921c02bcd4051f49c3a0f9c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bbae79c68b94513e3f510817c4a3bbfeb7690c8921c02bcd4051f49c3a0f9c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bbae79c68b94513e3f510817c4a3bbfeb7690c8921c02bcd4051f49c3a0f9c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9286716378181ec75248e4f652951cfcc256c831aa7289d4543df420dec654e4"
    sha256 cellar: :any_skip_relocation, ventura:       "9286716378181ec75248e4f652951cfcc256c831aa7289d4543df420dec654e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cf9f186a122939ab9b0342a7e41e4c8be8d8f00146db8c70aee23f861b9930f"
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