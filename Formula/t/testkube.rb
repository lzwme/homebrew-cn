class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.19.tar.gz"
  sha256 "ed70e33ed6419a2ba211f5d3090ac774fd510238ec43dd3701f789537243df4a"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69d87e34f16580439b72999f33cc258212501f477f246294e5fd3b90b0099628"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "066e004aae37e24ccd9907d408c8d00441953684daacd2897daf36570d4d0500"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55db34ac83f8b805d064dc6dedcf8fac829bdbe6ec91472423c0f37ac02dbf82"
    sha256 cellar: :any_skip_relocation, sonoma:         "827b1834c2fda2479230d49dfd669654be95ad576ca99d731ae2277885e48711"
    sha256 cellar: :any_skip_relocation, ventura:        "b90def6c564e51dcf8c45a2968c612e9c9b4974fdbcacb47a0971b4b14eebdb5"
    sha256 cellar: :any_skip_relocation, monterey:       "6e3ec6c9d51a289b6d88180a84d4aef0275a9f5d231ec6bbd27e87a234f2f83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdb31922fd52b928d2eb698159b15f9de7575b8da32854398193d4f636ef1b76"
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