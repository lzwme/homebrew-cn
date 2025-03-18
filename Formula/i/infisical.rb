class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.36.18.tar.gz"
  sha256 "7ae496022ab4993f3818d14d073c31095fcdf7538463c52c47d59fabace457ba"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2d64ed05af8ec66dd7e274c75ba664e1743d5327fbcd7492e864a7ff4020f6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2d64ed05af8ec66dd7e274c75ba664e1743d5327fbcd7492e864a7ff4020f6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2d64ed05af8ec66dd7e274c75ba664e1743d5327fbcd7492e864a7ff4020f6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a6a34b957d5d3f641adecc23afc760c0acfa436967d79606bafa2177cb47253"
    sha256 cellar: :any_skip_relocation, ventura:       "1a6a34b957d5d3f641adecc23afc760c0acfa436967d79606bafa2177cb47253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fe6d24730a1213e976d5ae656ea8bd1063019057a955b45d3bbaa0b172bcbf3"
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