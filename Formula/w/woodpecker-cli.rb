class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv2.8.0.tar.gz"
  sha256 "bd32ea13a83c4622bd150ed916b1ccdb8e086f54e9ef7d7500295b0ec769e23d"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0906c734302939e9d2ababe5ec587ec7ab3ae0beed6e23272604ed9d5059365e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0906c734302939e9d2ababe5ec587ec7ab3ae0beed6e23272604ed9d5059365e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0906c734302939e9d2ababe5ec587ec7ab3ae0beed6e23272604ed9d5059365e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bf3fd84b7b4ff287c506cf303f6d1355ce09357712e9ba337e871339ab33437"
    sha256 cellar: :any_skip_relocation, ventura:       "7bf3fd84b7b4ff287c506cf303f6d1355ce09357712e9ba337e871339ab33437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dd602beada6e0de95c4eaceef2ae5e1c26bb1831ff075125525999d4b01c700"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.orgwoodpeckerv#{version.major}version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"
  end

  test do
    output = shell_output("#{bin}woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not yet set up", output

    output = shell_output("#{bin}woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}woodpecker-cli --version")
  end
end