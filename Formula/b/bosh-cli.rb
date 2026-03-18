class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghfast.top/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.10.0.tar.gz"
  sha256 "7a592f2d640032f58893ce03a59c875469c6b4c2d5fec9a34fee9ed751aee48f"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05a03797f04c98c5a2bc51ef0e23c3f0acd87d8ee598d8c4bd3d3d6ec74f45a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05a03797f04c98c5a2bc51ef0e23c3f0acd87d8ee598d8c4bd3d3d6ec74f45a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05a03797f04c98c5a2bc51ef0e23c3f0acd87d8ee598d8c4bd3d3d6ec74f45a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "22e41c7893c7d29029f930d89325783b051aa9a582b575b8e9aa552e78476fe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea900e724fae85da876fb05e24d3d05fb9547afbde4806fd103a1fc61173d176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "667cebba5b835dd2e5b9aa4ac178dd34dfcecadd2805ed7884657553d37b3ae5"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end