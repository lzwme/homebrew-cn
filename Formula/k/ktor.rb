class Ktor < Formula
  desc "Generates Ktor projects through the command-line interface"
  homepage "https:github.comktorioktor-cli"
  url "https:github.comktorioktor-cliarchiverefstags0.2.0.tar.gz"
  sha256 "03c7d45cd5c73600fbbd20b194668b3e3844fc77e652394ddd75ad9e19d481c0"
  license "Apache-2.0"
  head "https:github.comktorioktor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2477ed41bf2cfe39653ddc1e61cd370eb8a79574798621aef5c3adfed537661"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2477ed41bf2cfe39653ddc1e61cd370eb8a79574798621aef5c3adfed537661"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2477ed41bf2cfe39653ddc1e61cd370eb8a79574798621aef5c3adfed537661"
    sha256 cellar: :any_skip_relocation, sonoma:         "0eb5d96c0bafe248c56d9434420403cf7e3d106aaf4da2397d2a090ce84cf787"
    sha256 cellar: :any_skip_relocation, ventura:        "0eb5d96c0bafe248c56d9434420403cf7e3d106aaf4da2397d2a090ce84cf787"
    sha256 cellar: :any_skip_relocation, monterey:       "0eb5d96c0bafe248c56d9434420403cf7e3d106aaf4da2397d2a090ce84cf787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ed8ea3a6a761a8f040b936e3cb4ee5a6a95e02989cc94dd1837fcbdbd3a3172"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "github.comktorioktor-clicmdktor"
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