class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghfast.top/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.9.tar.gz"
  sha256 "361c609b08795b6b337bdcefbd1af801f719eab33fa7fb095598f0ea8f8f35df"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "015c7ab7ecff6f256196a7937daf3b6b1e3054a43a1a6f79937ac94d67771cd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "015c7ab7ecff6f256196a7937daf3b6b1e3054a43a1a6f79937ac94d67771cd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "015c7ab7ecff6f256196a7937daf3b6b1e3054a43a1a6f79937ac94d67771cd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "54f2293f7cecdecf17fb3ef4437b58925e7f1eeb22198328268bab773dacf2e4"
    sha256 cellar: :any_skip_relocation, ventura:       "54f2293f7cecdecf17fb3ef4437b58925e7f1eeb22198328268bab773dacf2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a58dda27bc00447698186fc2a7b8d4be7281637716e6a822372dba6618bb2e6a"
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