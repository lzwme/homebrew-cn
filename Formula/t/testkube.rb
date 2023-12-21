class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.16.18.tar.gz"
  sha256 "16eacc1ef4345c7344a5b51cf57ee8659c84f7129f0f5c27e27f9fcd6929be8c"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8946c1fff210eb099331f6c98ec438a786439dfc25131410dac472d2be71a809"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb668d98787e6a869cbf7b2655c339ffd46f048605d1b8fff0cd9bdb1a3e0c6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c562f3e39726561ae4872068f584bc35f4eda09db674a883dd71ec3dd8c7a610"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0ccfff7d48f904e7e28eefbffa8631f41ec95b56f4850dd65ff5c9712272911"
    sha256 cellar: :any_skip_relocation, ventura:        "768ffbce58afaa49074143f9df98f77e2bebd07b8e68eec7e4931bcd2837015e"
    sha256 cellar: :any_skip_relocation, monterey:       "c6c6e322f6944c3dd41479e73cb92f9565afa8443abcc2abbd95201a713a104b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "132fc30ce9c972339c4e59feecc250338333ca00afa882ce7e96e68be5f25639"
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

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags: ldflags),
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