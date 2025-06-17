class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https:www.massdriver.cloud"
  url "https:github.commassdriver-cloudmassarchiverefstags1.11.2.tar.gz"
  sha256 "b8e5893d54383cb440a72ecdac9679baf6a4d5c134ecab07f4dc9beda4fae147"
  license "Apache-2.0"
  head "https:github.commassdriver-cloudmass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f6cddd55b5f57c582fa5ca59cae6e1711489f202393728bba86d5fd20886f91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f6cddd55b5f57c582fa5ca59cae6e1711489f202393728bba86d5fd20886f91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f6cddd55b5f57c582fa5ca59cae6e1711489f202393728bba86d5fd20886f91"
    sha256 cellar: :any_skip_relocation, sonoma:        "b07c4bdddec6358a033d6055595ae71f0384afb7423cb640749b8df532152aee"
    sha256 cellar: :any_skip_relocation, ventura:       "b07c4bdddec6358a033d6055595ae71f0384afb7423cb640749b8df532152aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59dd5b4d01f8f6e880dac588873672ba85c2a213021f53ab07301c0b025a8a16"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commassdriver-cloudmasspkgversion.version=#{version}
      -X github.commassdriver-cloudmasspkgversion.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"mass")

    generate_completions_from_executable(bin"mass", "completion")
  end

  test do
    output = shell_output("#{bin}mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}mass version")
  end
end