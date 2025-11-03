class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://ghfast.top/https://github.com/toitlang/jaguar/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "bd7dacf231a1393b9984f80774a827e106dbaf12fffea4035def8b10c1074666"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0da8cea5e952c7db78360a0d34c697e52ef2bc57ca44ac3023469a476e07ea4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0da8cea5e952c7db78360a0d34c697e52ef2bc57ca44ac3023469a476e07ea4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0da8cea5e952c7db78360a0d34c697e52ef2bc57ca44ac3023469a476e07ea4"
    sha256 cellar: :any_skip_relocation, sonoma:        "21c3f2ead0853ee33a6c4819e18e0582068cc006829f79106c3b49abacd7534c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fb28107d2eb6b6dbd26499e8465f2f6b675274bde2ff41be1fc0c061f85a4d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f309dac7f35ad2c9390b907ee3dfb9149120185ef9d9a568eb81b4329ef2fb7c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jag"), "./cmd/jag"

    generate_completions_from_executable(bin/"jag", "completion")
  end

  test do
    assert_match "Version:\t v#{version}", shell_output("#{bin}/jag --no-analytics version 2>&1")

    (testpath/"hello.toit").write <<~TOIT
      main:
        print "Hello, world!"
    TOIT

    # Cannot do anything without installing SDK to $HOME/.cache/jaguar/
    assert_match "You must setup the SDK", shell_output("#{bin}/jag run #{testpath}/hello.toit 2>&1", 1)
  end
end