class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://ghproxy.com/https://github.com/FairwindsOps/pluto/archive/v5.16.3.tar.gz"
  sha256 "e67ff271a790fa4607410ec249c9a15a023d52a117ba8da75414b9fe857c0bdf"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d7450f2ad5d13ab61c109d0111dc29e853639c279ef7b29cb806b45502db686"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d7450f2ad5d13ab61c109d0111dc29e853639c279ef7b29cb806b45502db686"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d7450f2ad5d13ab61c109d0111dc29e853639c279ef7b29cb806b45502db686"
    sha256 cellar: :any_skip_relocation, ventura:        "dc7a890972acdd42828b571f2b46814530a9262864608c541c2d277e8f043e99"
    sha256 cellar: :any_skip_relocation, monterey:       "dc7a890972acdd42828b571f2b46814530a9262864608c541c2d277e8f043e99"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc7a890972acdd42828b571f2b46814530a9262864608c541c2d277e8f043e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aaaf927a8a213e8e40761f673517fbe71b0e7e677764289696c06bd64c29ff5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~EOS
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml")
  end
end