class Ktor < Formula
  desc "Generates Ktor projects through the command-line interface"
  homepage "https:github.comktorioktor-cli"
  url "https:github.comktorioktor-cliarchiverefstags0.3.0.tar.gz"
  sha256 "32a6ded9d4b27de47a4d628894d892bb464a984dcd762e5678b3aa2dee0095d5"
  license "Apache-2.0"
  head "https:github.comktorioktor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc9d7a77698749a4f3794d4dc6554bfe340124fce946052c3a07590e37fd4428"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc9d7a77698749a4f3794d4dc6554bfe340124fce946052c3a07590e37fd4428"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc9d7a77698749a4f3794d4dc6554bfe340124fce946052c3a07590e37fd4428"
    sha256 cellar: :any_skip_relocation, sonoma:        "89c03c35c64647ed36aac771b4f09eacbdee8566a2ea459aa8c6473515759b73"
    sha256 cellar: :any_skip_relocation, ventura:       "89c03c35c64647ed36aac771b4f09eacbdee8566a2ea459aa8c6473515759b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f3a77be3b68e5095fd14eb239d7c439ee46f76ee341096f6136fb452dad4a69"
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