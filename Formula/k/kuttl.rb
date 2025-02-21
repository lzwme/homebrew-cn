class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https:kuttl.dev"
  url "https:github.comkudobuilderkuttlarchiverefstagsv0.22.0.tar.gz"
  sha256 "45777fdca82d14030b9661a2819b15e6380a9f4b0f8bbcfd826d8b21ffae7803"
  license "Apache-2.0"
  head "https:github.comkudobuilderkuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a200c41971635ed7a3653587e733f9ba432eef06741e418c9ca76ff8f8164d54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a200c41971635ed7a3653587e733f9ba432eef06741e418c9ca76ff8f8164d54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a200c41971635ed7a3653587e733f9ba432eef06741e418c9ca76ff8f8164d54"
    sha256 cellar: :any_skip_relocation, sonoma:        "02527ab79b8757cbdef026cf010d835ab249bcc7eef92c23900490afa334521f"
    sha256 cellar: :any_skip_relocation, ventura:       "02527ab79b8757cbdef026cf010d835ab249bcc7eef92c23900490afa334521f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bda78e3404303c5bfcdc8f9a7d0c9b39c1315be6bce046589de118146e587712"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    project = "github.comkudobuilderkuttl"
    ldflags = %W[
      -s -w
      -X #{project}pkgversion.gitVersion=v#{version}
      -X #{project}pkgversion.gitCommit=#{tap.user}
      -X #{project}pkgversion.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(output: bin"kubectl-kuttl", ldflags:), ".cmdkubectl-kuttl"
    generate_completions_from_executable(bin"kubectl-kuttl", "completion")
  end

  test do
    version_output = shell_output("#{bin}kubectl-kuttl version")
    assert_match version.to_s, version_output
    assert_match stable.specs[:revision].to_s, version_output

    kubectl = Formula["kubernetes-cli"].opt_bin  "kubectl"
    assert_equal version_output, shell_output("#{kubectl} kuttl version")

    (testpath  "kuttl-test.yaml").write <<~YAML
      apiVersion: kuttl.devv1beta1
      kind: TestSuite
      testDirs:
      - #{testpath}
      parallel: 1
    YAML

    output = shell_output("#{kubectl} kuttl test --config #{testpath}kuttl-test.yaml", 1)
    assert_match "running tests using configured kubeconfig", output
    assert_match "fatal error getting client: " \
                 "invalid configuration: " \
                 "no configuration has been provided, try setting KUBERNETES_MASTER environment variable", output
  end
end