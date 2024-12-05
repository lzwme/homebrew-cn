class Ktor < Formula
  desc "Generates Ktor projects through the command-line interface"
  homepage "https:github.comktorioktor-cli"
  url "https:github.comktorioktor-cliarchiverefstags0.3.1.tar.gz"
  sha256 "d733b4e1bdb6dc1c24bdc5952805449e5fab974728c1491cbb680d94c88687bd"
  license "Apache-2.0"
  head "https:github.comktorioktor-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f9d214cf75ad4f2555dc0d750cba7b2e6f28e250d31ee732e42dfa2b8c50ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0f9d214cf75ad4f2555dc0d750cba7b2e6f28e250d31ee732e42dfa2b8c50ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0f9d214cf75ad4f2555dc0d750cba7b2e6f28e250d31ee732e42dfa2b8c50ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "be132ece24c7bf5519f46e62d18b79265f1962082f2095d06633fb79b0adf9b0"
    sha256 cellar: :any_skip_relocation, ventura:       "be132ece24c7bf5519f46e62d18b79265f1962082f2095d06633fb79b0adf9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3029deef9706edbf7768a9e46191bdde459f2a0c547ab869aee5499ea7e695d5"
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