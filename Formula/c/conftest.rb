class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https:www.conftest.dev"
  url "https:github.comopen-policy-agentconftestarchiverefstagsv0.49.0.tar.gz"
  sha256 "de076ad500d4f78f7f5501b116bf225cd417e7b910f742cb9ca0c3c6e4ecf3bc"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentconftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a3741edd2e132314f663912851e9eca592cb276770f241d57623c21758940fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28760520a3ef6736db2e745ebd94e58880045b6442b75527778abcc8976fd6b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dd1d8c59dd502791e5e8c000faebfb228c5ffc5798054e775b947d2977f7c74"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fbd67fdeccc2ce54e5c2b4e7020e6bee0668c463c44db75a900492763a2ca8e"
    sha256 cellar: :any_skip_relocation, ventura:        "779d58625adf3332b6712f07d5a6e708cbda454182d2ac5b243c849d6b9d840f"
    sha256 cellar: :any_skip_relocation, monterey:       "d7a80d7cbc92a440f16608a71c6da3c121302fdc6a3e07aa265869e7f4b8a25e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be6467c7e3962e02512b841e73c82c1fbcd034e945ec607516ef29961533bed0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.comopen-policy-agentconftestinternalcommands.version=#{version}")

    generate_completions_from_executable(bin"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath"test.rego").write("package main")
    system "#{bin}conftest", "verify", "-p", "test.rego"
  end
end