class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https:fairwinds.com"
  url "https:github.comFairwindsOpsplutoarchiverefstagsv5.20.1.tar.gz"
  sha256 "5cdcd310f222c8a2f9fde8dc682c5299942cf56747793d0a62da7943f0172253"
  license "Apache-2.0"
  head "https:github.comFairwindsOpspluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "015b055280945fd7fc9790aa60a217f13d14f689f3e7ffaab2dff42336d62395"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "015b055280945fd7fc9790aa60a217f13d14f689f3e7ffaab2dff42336d62395"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "015b055280945fd7fc9790aa60a217f13d14f689f3e7ffaab2dff42336d62395"
    sha256 cellar: :any_skip_relocation, sonoma:         "27fd0ad83840e74e3d4ad09c1ceb3d8be3508916d24eff8d6524657855f121c7"
    sha256 cellar: :any_skip_relocation, ventura:        "27fd0ad83840e74e3d4ad09c1ceb3d8be3508916d24eff8d6524657855f121c7"
    sha256 cellar: :any_skip_relocation, monterey:       "27fd0ad83840e74e3d4ad09c1ceb3d8be3508916d24eff8d6524657855f121c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0945090d6043595b9d378c2154799633b264346ad0d3763e3772e20c683053f3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmdplutomain.go"
    generate_completions_from_executable(bin"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pluto version")
    assert_match "Deployment", shell_output("#{bin}pluto list-versions")

    (testpath"deployment.yaml").write <<~EOS
      apiVersion: extensionsv1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}pluto detect deployment.yaml", 3)
  end
end