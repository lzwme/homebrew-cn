class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https:www.conftest.dev"
  url "https:github.comopen-policy-agentconftestarchiverefstagsv0.61.1.tar.gz"
  sha256 "9f17da54e2be10a5b181f18f68349a08c4a4e3e37fdf6474436642f56a6d85e8"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentconftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8b03382894da082165886e5bf4f4f1e6ded9fc68bde4f6048e05d69f6e32e8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a37b25ee1fbe0b3cbe6ee28109143647229ce58e0860f13614ab292b9008f6a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78efeda48178e09491a4b4efcd6aa39b590816127ff6e49647353503ffb8a6a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0585ee763e4db8593b9efbbe8f94b220a61f75941e5221bca8001e132e31b19e"
    sha256 cellar: :any_skip_relocation, ventura:       "955b2aa37b9f940bfc33ffeca06487f70b6afd0c835911d4aef10ee78c973e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7f499a4acd18ff3496a9d161a428ee987de11bccda61d7f79e564b00953ade8"
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