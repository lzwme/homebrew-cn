class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.36.15.tar.gz"
  sha256 "9a6a0dbdcbbf77d65064e50d8396788eb3d862e5fd61c888d547289ff276f368"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "673c77b9247ea9f34c50c594ad768b912bd48f2e506c40ad50af056aa89bfbce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "673c77b9247ea9f34c50c594ad768b912bd48f2e506c40ad50af056aa89bfbce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "673c77b9247ea9f34c50c594ad768b912bd48f2e506c40ad50af056aa89bfbce"
    sha256 cellar: :any_skip_relocation, sonoma:        "9388baa048a0508f2c9c398ed99779e019a1a70688d0decd570cadc2b35742b1"
    sha256 cellar: :any_skip_relocation, ventura:       "9388baa048a0508f2c9c398ed99779e019a1a70688d0decd570cadc2b35742b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d72a3d1a504395ca94cf0947af06c89b1f53b33a09400c0264be19856ac6a3fe"
  end

  depends_on "go"

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