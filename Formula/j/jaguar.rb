class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://ghfast.top/https://github.com/toitlang/jaguar/archive/refs/tags/v1.61.0.tar.gz"
  sha256 "a32ddad9663c254eae60af0aea4f9379d1cc96f25a71700a1c287fa1e1bde321"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "190d9f73659be0e3e0a1288743b3f502f4d4b06dcef4e408008994248ebe3ab0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "190d9f73659be0e3e0a1288743b3f502f4d4b06dcef4e408008994248ebe3ab0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "190d9f73659be0e3e0a1288743b3f502f4d4b06dcef4e408008994248ebe3ab0"
    sha256 cellar: :any_skip_relocation, sonoma:        "60737b1dd555b4c5296543437b062053cd246897b361bcf8221c8fd5d1832bda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c898b70060c0d56290da7ed067df9907fe5a624e963ef58bac381f0b35900b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83257defc6586e7eddf2a3c993add2294646a14ffc0d57c8258618a969e2b5ab"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jag"), "./cmd/jag"

    generate_completions_from_executable(bin/"jag", shell_parameter_format: :cobra)
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