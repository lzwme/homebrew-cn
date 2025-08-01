class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghfast.top/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.8.tar.gz"
  sha256 "444e39eefcb2fd00ad4e4d9394e32bc23aef3520f2a22b92ed72b5f196fd9a49"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05057d47330b5a0022899e2f87d05a1beedc70324f85dc7d9a20db9ed4e04b8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05057d47330b5a0022899e2f87d05a1beedc70324f85dc7d9a20db9ed4e04b8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05057d47330b5a0022899e2f87d05a1beedc70324f85dc7d9a20db9ed4e04b8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e63149ade9a7425be5b0f11a2155291435f61eb92e4e881660d3c9f1b8f51a3"
    sha256 cellar: :any_skip_relocation, ventura:       "5e63149ade9a7425be5b0f11a2155291435f61eb92e4e881660d3c9f1b8f51a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "998f063c25c4986e4f517c4ae075ef88c209f36f029c3024275f94d4c3e11315"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end