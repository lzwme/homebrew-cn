class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https:toitlang.org"
  url "https:github.comtoitlangjaguararchiverefstagsv1.49.0.tar.gz"
  sha256 "2af8666ad6f46deac0b802e5f404a461aad056744ae083f239853028082d4d23"
  license "MIT"
  head "https:github.comtoitlangjaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4010fa17e6d3113dcc6da3df6d45ea8e2c4e70d554731f71244e00107d1e586c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4010fa17e6d3113dcc6da3df6d45ea8e2c4e70d554731f71244e00107d1e586c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4010fa17e6d3113dcc6da3df6d45ea8e2c4e70d554731f71244e00107d1e586c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7719ece73bbad519d904829338fb913f921c28e1385cfc2c5f960bbd195865af"
    sha256 cellar: :any_skip_relocation, ventura:       "7719ece73bbad519d904829338fb913f921c28e1385cfc2c5f960bbd195865af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3f778744f9b34b49f24032a2d33d400342eece986f25ff5d271538203c04feb"
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