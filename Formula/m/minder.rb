class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.66.tar.gz"
  sha256 "7842c124cdc7f80e5df1f83a4b936ddb46d560aeb19554541b29d838fd419813"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7029496c390acedc47178c3e6e0ff9ca5e38164e8ec1965bd3073af79bfac1fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7029496c390acedc47178c3e6e0ff9ca5e38164e8ec1965bd3073af79bfac1fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7029496c390acedc47178c3e6e0ff9ca5e38164e8ec1965bd3073af79bfac1fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f45c30646330c149a0f4227cc48b9bdd2911baaac03eae8b117ac42326923fa6"
    sha256 cellar: :any_skip_relocation, ventura:       "ef3564256a3e87f85e4b1a6b2d5b025205ff60d8421f664aadcd0f35e5205ef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f0c818ceee9f15102b1baf057a268506fb1ccd6cfb7dd588291a7937968e8b3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commindersecminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end