class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https:toitlang.org"
  url "https:github.comtoitlangjaguararchiverefstagsv1.50.1.tar.gz"
  sha256 "d62f267092fdcfaa46df28409514db396e63ff5d83eb3c18b6fcbd6ab8813438"
  license "MIT"
  head "https:github.comtoitlangjaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d1658a583ed6ef713448799e8cda7cf8e36748eed88f7fa305fd653ef200c0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d1658a583ed6ef713448799e8cda7cf8e36748eed88f7fa305fd653ef200c0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d1658a583ed6ef713448799e8cda7cf8e36748eed88f7fa305fd653ef200c0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a0217e92c796b849860cafecdc3e10a2e9fb76c28707e4f8f3c55ac5f7ba522"
    sha256 cellar: :any_skip_relocation, ventura:       "8a0217e92c796b849860cafecdc3e10a2e9fb76c28707e4f8f3c55ac5f7ba522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7828eb0e038a9b353b8925f18a5b0a875449eb12039bf8c9a2852da8d3e3e38a"
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