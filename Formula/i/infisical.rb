class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.41.2.tar.gz"
  sha256 "3acf82b51453681bb70a77373ce03c22ff544b5ae2c29f8e124687504de0012a"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0199f07e2099a2b247298ebca3718479c0fc39d5f8581a203bb65436554d711f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0199f07e2099a2b247298ebca3718479c0fc39d5f8581a203bb65436554d711f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0199f07e2099a2b247298ebca3718479c0fc39d5f8581a203bb65436554d711f"
    sha256 cellar: :any_skip_relocation, sonoma:        "02b355e3bfebc24b0869a75d78e056f06ae638ec116f9e817e8b063d2a0bfb56"
    sha256 cellar: :any_skip_relocation, ventura:       "02b355e3bfebc24b0869a75d78e056f06ae638ec116f9e817e8b063d2a0bfb56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a73cef48b6a13d7359ff80116d6fa35eae3a7d245e116bdcc317e043fc90c8c"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.comInfisicalinfisical-mergepackagesutil.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}infisical --version")

    output = shell_output("#{bin}infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end