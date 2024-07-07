class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https:www.conftest.dev"
  url "https:github.comopen-policy-agentconftestarchiverefstagsv0.54.0.tar.gz"
  sha256 "a46c99be716571cd087eadba522b1c54d3699de3a2316588489d43deebf337de"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentconftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c789c04f7fd6009b36af447611951c2b3d46f0da247541ec6df014b6689dd95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3f3686ddf6fea76ba5df6559c8051e20c7f6d206164952a1d9bcd2725923dce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5c8cbad229808ce47a65d061115028778ad2479f23e01333cc477c970ee2438"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f529a6ba9d9e8cdbdce3b615ae22684d47e8eda1258a829aa0855678b753421"
    sha256 cellar: :any_skip_relocation, ventura:        "75177ad365466d25b70eebce00b4926df70bf242b43ed5206da802e0b3a25d58"
    sha256 cellar: :any_skip_relocation, monterey:       "9093db0f85e16cd1245b8cb7c21bc1870c012a622ae516c826803025a5e04b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb6714fa7277da83e87a0ac2f6887abe84341442352f87ad682fea3f371e64d"
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