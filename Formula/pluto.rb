class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://ghproxy.com/https://github.com/FairwindsOps/pluto/archive/v5.16.0.tar.gz"
  sha256 "bdbfe9a11ebbcf5df9f16ce432bb7b78bd4b310bdb31445675d714b3f99fb40a"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2c3732c09aa8ee44b38c7e6c0426efcf7fbb3257c2373a1775c76727493306a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "834a9c8a588b4a9dd36d14eea2f9bac21da64177f59d3b3a64fd84be9d6d77a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2c3732c09aa8ee44b38c7e6c0426efcf7fbb3257c2373a1775c76727493306a"
    sha256 cellar: :any_skip_relocation, ventura:        "17dd2b0ec57fbf66f8cb7352d17dbb3ea8389fa13ea5c14598933055a7bcbcb4"
    sha256 cellar: :any_skip_relocation, monterey:       "17dd2b0ec57fbf66f8cb7352d17dbb3ea8389fa13ea5c14598933055a7bcbcb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "17dd2b0ec57fbf66f8cb7352d17dbb3ea8389fa13ea5c14598933055a7bcbcb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d78dcdf090c81f1d3f34395342b612dbbe6a8d450d3c560f0763b4e5ce1f2901"
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