class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.50.4.tar.gz"
  sha256 "6928d46b9fa656097ccde3c214b3318e1c986d6d293829f01f95726d2a1d8051"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58e06bb2471fd2427894727734e85d1ba5c42c1f28b439db1f5ea97608bf4dcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a7be95610f4407e36ae0a4a5a6a6cf1f321e24e6574da70c995ee55276eb0e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "602d5c8d07e25b0dbdc7c0a0659be8329f1c1d0b61788c820dcf3b37bc3b0ef0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d11f78ea1cbad1586c07464f8f2337cc88b3d2ca09a97cf1bdf86db8837f5d46"
    sha256 cellar: :any_skip_relocation, ventura:        "bbb338eb11b04e307eab2c453bb216799254e055d85b75228fe07ff900b43cdb"
    sha256 cellar: :any_skip_relocation, monterey:       "eada3885ff0f7f1fc720ed439774b45003fa0474cb364f676d01a8d37dcf4df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a7922db7b2e7f32a7fb27361dc7543ef95927ae4f3bbe68c0f1e4ea64862fab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end