class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https:toitlang.org"
  url "https:github.comtoitlangjaguararchiverefstagsv1.51.0.tar.gz"
  sha256 "87cd58bca9d8ff4d6be6c22a3b5c62b76aab81e8298cd3cd5f7b265f5947e5f3"
  license "MIT"
  head "https:github.comtoitlangjaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "963d22d8a13fae117c811c0ca722640d4a2b3d3bbd47dba0029fe1d2f7291404"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "963d22d8a13fae117c811c0ca722640d4a2b3d3bbd47dba0029fe1d2f7291404"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "963d22d8a13fae117c811c0ca722640d4a2b3d3bbd47dba0029fe1d2f7291404"
    sha256 cellar: :any_skip_relocation, sonoma:        "88a4001106d27e68ae85e818910ad7c269fb4211d43f2e2be41143f785b77eec"
    sha256 cellar: :any_skip_relocation, ventura:       "88a4001106d27e68ae85e818910ad7c269fb4211d43f2e2be41143f785b77eec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d13bc01462df5a7e34f7390b3d86b4ef2ee0b121687a9c2b1a7459c985277e42"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"jag"), ".cmdjag"

    generate_completions_from_executable(bin"jag", "completion")
  end

  test do
    assert_match "Version:\t v#{version}", shell_output(bin"jag --no-analytics version 2>&1")

    (testpath"hello.toil").write <<~TOIL
      main:
        print "Hello, world!"
    TOIL

    # Cannot do anything without installing SDK to $HOME.cachejaguar
    assert_match "You must setup the SDK", shell_output(bin"jag run #{testpath}hello.toil 2>&1", 1)
  end
end