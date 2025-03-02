class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https:www.conftest.dev"
  url "https:github.comopen-policy-agentconftestarchiverefstagsv0.58.0.tar.gz"
  sha256 "8e05441792b3b5e3bfff14f385dfaf13f0d5ab215ba1665aa7a2deda8990f39c"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentconftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f436d496022cc2f90d49f050463ac80ec866ba2bc67162e06626c6b1b973f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bad2f6e921d2d363bf95903bfc9fb87260bacf309af1bc3234a79d7716d5441f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30df14c177a304cf30827b9bca89852a3a276a5b290002304d23059d4b39cc30"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb4c3dfb573e9361c6a4f1d410d1bc17942d200e1f2e6b6fd7528acee06b86d"
    sha256 cellar: :any_skip_relocation, ventura:       "8eff2d806f6922fe6cd422f09ee0778f89ff5f071a96725c11aab98b1061a3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29bd8a1ac346d6e531512c84f92fbed795dd646aafad4274b438331b8db15af0"
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