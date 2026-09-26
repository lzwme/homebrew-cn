class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghfast.top/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.11.0.tar.gz"
  sha256 "e8d18fa5a2d5dae2a5f5ee554df47cc662cd5144543a3133e9afe3708ce2db10"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a1171c37410c28762967d56bf4cd0a4d42a034f2ebda2b75ddd2ea9c7ba0be8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a1171c37410c28762967d56bf4cd0a4d42a034f2ebda2b75ddd2ea9c7ba0be8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a1171c37410c28762967d56bf4cd0a4d42a034f2ebda2b75ddd2ea9c7ba0be8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f37232694f50d270d72429bea36c8f31e96f75e6a571d0d6d00337bc6d688d70"
    sha256 cellar: :any,                 x86_64_linux:      "c134d8d34918d3885eaccf20237d10b4a98511e07d05c1c1f7a959d42a8b4728"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end