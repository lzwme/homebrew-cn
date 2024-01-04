class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https:www.conftest.dev"
  url "https:github.comopen-policy-agentconftestarchiverefstagsv0.48.0.tar.gz"
  sha256 "3f1d59d39431ed5b847cfd2a3aeda3eadb488454de25f3eb488cfc5c1f698707"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentconftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d901360ccb43214b8c7e52fcda0703564ca0ad854423058705fde78b32abe4e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fd7d4431ae7719115dee5aea387b6e48a999082ab3db0ea617764f972d2112b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8de3fa28c27d58b189918257320866b99934783cabcaec2c5a3b7161d9efdc1"
    sha256 cellar: :any_skip_relocation, sonoma:         "133433dc5c5fdb41a61afa003e9f846e9be1facdc199d77692af18bd6ae74c81"
    sha256 cellar: :any_skip_relocation, ventura:        "7ab530a61d671488137c19033564df331495759152403baecad00024c0e0af4f"
    sha256 cellar: :any_skip_relocation, monterey:       "4b14e164fb3d6045297e96d51fa1605d7dbf4394a198ee8198bbdb127474aa37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e1e832cb5fa68711238fd7af719d640f1521c8acf63b87df01de6ae1e771455"
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