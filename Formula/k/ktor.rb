class Ktor < Formula
  desc "Generates Ktor projects through the command-line interface"
  homepage "https:github.comktorioktor-cli"
  url "https:github.comktorioktor-cliarchiverefstags0.5.0.tar.gz"
  sha256 "6bc452b6aa7e4a911649f10359a0c00d0017e8ab3a3c70b0e1412c026794f6a3"
  license "Apache-2.0"
  head "https:github.comktorioktor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cf749408d5001e9ed47c16c6438aeeeb2a3154f784d4bc950ceafefa9031e3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cf749408d5001e9ed47c16c6438aeeeb2a3154f784d4bc950ceafefa9031e3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cf749408d5001e9ed47c16c6438aeeeb2a3154f784d4bc950ceafefa9031e3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e13a398f0340d51f04717c0fa03e6d4f6fb844b18714573bbc2aafff7f67a20"
    sha256 cellar: :any_skip_relocation, ventura:       "3e13a398f0340d51f04717c0fa03e6d4f6fb844b18714573bbc2aafff7f67a20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff37eac131a596a2c4006ff9e90f3d3250c2f34b9c982cd30a969dec74b7d76a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdktor"
  end

  test do
    assert_match "Ktor CLI version #{version}", shell_output("#{bin}ktor --version")
    assert_match "Ktor CLI version #{version}", shell_output("#{bin}ktor version")
    system bin"ktor", "new", "project"
    assert_path_exists testpath"projectbuild.gradle.kts"
    assert_path_exists testpath"projectsettings.gradle.kts"
    assert_path_exists testpath"projectgradle.properties"
    assert_path_exists testpath"projectsrc"
    assert_path_exists testpath"projectgradle"
  end
end