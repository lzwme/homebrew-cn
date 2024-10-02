class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.15.1.tar.gz"
  sha256 "007942bc10d6adf0886a8f22e5634cbfc5e894bc7df691bc9a82d7aff2bbc7a7"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1d549c04b960f749efc0469fa0a277d9d64edf9c88dcc2e3db82805604043b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf76cfe15fca6c8813bddc1030fea9de3b891b5dd3f16c30f111e4e4f7f22b67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fba0b1733ce0f6a838b56a4df9ff6b10919b9a50d6e008f577847a01c66ed72"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf1b9b1aa5364883f7972ded98f84f9d8e0ff114b00c334cae1dd10aa744401e"
    sha256 cellar: :any_skip_relocation, ventura:       "59cd1d44eeb7873f29b553c4aa66feefae0ec64b3491425e86fae1e1842b23a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4508da2436cd0f5fc7fa875c7da65640ca19654f7fdb159498f2233533a527e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end