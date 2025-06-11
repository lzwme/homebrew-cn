class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https:www.conftest.dev"
  url "https:github.comopen-policy-agentconftestarchiverefstagsv0.61.2.tar.gz"
  sha256 "af8138e94ebd602ca98e0af3320669230130abfcc2a042ce9e35d301b4144863"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentconftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db6f9c83b30924132636d3fc79e5f448a944f3bb4a1c50d8a99c42135204d7f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49902ad148ff9dda20a360e1d34eeb458c76d82d5f5c52c1942cfe7b5105a728"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12179f5f96616530dab437b122e43a50b00b1a16ac2587ca6adb0e3ecb9000d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a6a1529c93bcea86a4c675e99a1d56c96caec59b595ec10fa1db101ba6be66b"
    sha256 cellar: :any_skip_relocation, ventura:       "fd8df9dcf0ad678106663307591413ff37e916ffff2cc15ad2c393240b64c48f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "675fbbc9fbb7585a71d07f05ac1dda26694e34829458ac30340a30583709d10d"
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