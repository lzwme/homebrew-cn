class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https:www.conftest.dev"
  url "https:github.comopen-policy-agentconftestarchiverefstagsv0.60.0.tar.gz"
  sha256 "85db17fba05e95594c30fd67dfdbef78e18cf0f87ab3537d987a8197e2c19911"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentconftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "effd49553b97c61f566f9e6f20088c720eef2d9cccb059991be421551724483c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e09a8c2da7662d8c109024e001e7ef49833718bdd5575779238fc4f313f20e2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01f9d2cc41bbdc7500639f6e396ff1c7c771291b428f6e76671a09079ae052c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ae1bff1b4b49e52187fd2f147265961ad59a99ab8de5b07d52bf0cac1bb80c8"
    sha256 cellar: :any_skip_relocation, ventura:       "5ea5d6a74c47a0945691a4482754050ed23f8363511a845ee88cf66a2b824b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcde20e3189d8bbbbd92b3c7339f0d40d720a5a42da5a50c6f243f23529b6144"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comopen-policy-agentconftestinternalcommands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath"test.rego").write("package main")
    system bin"conftest", "verify", "-p", "test.rego"
  end
end