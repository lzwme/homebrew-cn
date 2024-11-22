class Ktor < Formula
  desc "Generates Ktor projects through the command-line interface"
  homepage "https:github.comktorioktor-cli"
  url "https:github.comktorioktor-cliarchiverefstags0.3.1.tar.gz"
  sha256 "d733b4e1bdb6dc1c24bdc5952805449e5fab974728c1491cbb680d94c88687bd"
  license "Apache-2.0"
  head "https:github.comktorioktor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b7a13b7df5cabdf75f7b5e672f53c01c60d83849222931f8b8d4adff4d6de91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b7a13b7df5cabdf75f7b5e672f53c01c60d83849222931f8b8d4adff4d6de91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b7a13b7df5cabdf75f7b5e672f53c01c60d83849222931f8b8d4adff4d6de91"
    sha256 cellar: :any_skip_relocation, sonoma:        "5695e2ba9dab74be6437b89e40655a77da6f174b46ff08560c7a25b3adc69fe6"
    sha256 cellar: :any_skip_relocation, ventura:       "5695e2ba9dab74be6437b89e40655a77da6f174b46ff08560c7a25b3adc69fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ea8d0c87d24e4d2adec9724111c151e4a2f9034a32a12ea979ada403a84ed5e"
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