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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c340eac3084e3d54a844d3fe29d3175dab1a032b615ff8af5597d5b7dff4c07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c340eac3084e3d54a844d3fe29d3175dab1a032b615ff8af5597d5b7dff4c07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c340eac3084e3d54a844d3fe29d3175dab1a032b615ff8af5597d5b7dff4c07"
    sha256 cellar: :any_skip_relocation, sonoma:        "94057dc9e7df850da8a2be71003dd961450689a96203df2a54da1706932cca82"
    sha256 cellar: :any_skip_relocation, ventura:       "94057dc9e7df850da8a2be71003dd961450689a96203df2a54da1706932cca82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfcfcf56cadcd6768b72f87ca9ce270ed41a07f95adf11c8cbe553d817754aef"
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

    (testpath"hello.toit").write <<~TOIT
      main:
        print "Hello, world!"
    TOIT

    # Cannot do anything without installing SDK to $HOME.cachejaguar
    assert_match "You must setup the SDK", shell_output(bin"jag run #{testpath}hello.toit 2>&1", 1)
  end
end