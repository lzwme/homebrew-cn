class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.36.23.tar.gz"
  sha256 "a030de6d0a27e7ff75968600221915e4fd8663bb97ead3401279141f552edc3d"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "341315ce25516f3281c649262001975ff350841f2fac2abab0e943d4158926b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "341315ce25516f3281c649262001975ff350841f2fac2abab0e943d4158926b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "341315ce25516f3281c649262001975ff350841f2fac2abab0e943d4158926b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "62a8a4f703dd5bab9cda4e3afd144bb21f1bb96807c3d1f0a6e227cf51d2a67e"
    sha256 cellar: :any_skip_relocation, ventura:       "62a8a4f703dd5bab9cda4e3afd144bb21f1bb96807c3d1f0a6e227cf51d2a67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7a20e2867aa98f9390c4d1100e45dd3ce919a3c77f97424a1c2ce267663709c"
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