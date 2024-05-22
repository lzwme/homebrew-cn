class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.42.tar.gz"
  sha256 "d75dd990c4165cb3a18e6900bd92854bb52b0a785b38e9d7fdcefcf58fcd87e1"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e51ad3f27ced018d4f8f1da7b51382b4f5e48b665b1d79ce456eea53a0cb1a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "465cd32a417354a7447d877bc265103918a8904f446857b529d60b74fb3c3e2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24dfa29b791a80023f1a0002762abdd645569fe7ca92af372504b86d9a17c864"
    sha256 cellar: :any_skip_relocation, sonoma:         "285df2308cd4c378d4bf7e124f91dcfea6629d0348f040195a594b1f18ead076"
    sha256 cellar: :any_skip_relocation, ventura:        "57bf0a37ddae6ac63d3c7b39b1dfd664ffd0aa7b62bdb260b9029ae13ec7a9ac"
    sha256 cellar: :any_skip_relocation, monterey:       "5c855013f031dfa847695b4ef710aa3b1570e06f59aef2c69d5cc9b1da25ab44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2519bd734029d32613de4c5a90630e1e829a94d1b73d9305a9e033c54c2cce27"
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