class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv2.7.2.tar.gz"
  sha256 "7ed15d4a99d819344853959c975d5d2df24a0e5a3d2736c74104a686a471fd50"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "218907781e02232405bac8490acede2a0e6d7f1b9a8a11c7f80a00c2619cfd48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "218907781e02232405bac8490acede2a0e6d7f1b9a8a11c7f80a00c2619cfd48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "218907781e02232405bac8490acede2a0e6d7f1b9a8a11c7f80a00c2619cfd48"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec94bbe2d2e360fa02d22b44a6a17d0eb52f5c21eea1b4c6d6d42c2459ce6fc9"
    sha256 cellar: :any_skip_relocation, ventura:       "ec94bbe2d2e360fa02d22b44a6a17d0eb52f5c21eea1b4c6d6d42c2459ce6fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "312618bf832e479632444be277d07b0dce727a77160256f1deda9e5a7b476984"
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