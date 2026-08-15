class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghfast.top/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.10.9.tar.gz"
  sha256 "69d548986a4261a43a932520ec6696c96d56e166db3401c6257a9a8c160a49d4"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0deebc894acd8d918f016e4c33e940066da0ac0055bd94bb522b5bfba705e02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0deebc894acd8d918f016e4c33e940066da0ac0055bd94bb522b5bfba705e02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0deebc894acd8d918f016e4c33e940066da0ac0055bd94bb522b5bfba705e02"
    sha256 cellar: :any_skip_relocation, sonoma:        "f842732d42127779421c6408bf4a777a5c5eaf0db0ccf8f9d55fe13e5cb2a197"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52424e0d266ea44748036af8cef2409998f46fc29553b845508166f46f198ba7"
    sha256 cellar: :any,                 x86_64_linux:  "5d33f1abc8788797afc6046202484259c6d28e4583801300b0b8ca531b89c0c0"
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