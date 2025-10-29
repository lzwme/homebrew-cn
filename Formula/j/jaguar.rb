class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://ghfast.top/https://github.com/toitlang/jaguar/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "4774ecdcc200b05253c0573fe1919c222789ac0e83cd463cf524f9e438c9f409"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19b4b0d70c80bcdf8e629f3a0a25c331a0d97b22a75ae7b76039f7904187acb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b4b0d70c80bcdf8e629f3a0a25c331a0d97b22a75ae7b76039f7904187acb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19b4b0d70c80bcdf8e629f3a0a25c331a0d97b22a75ae7b76039f7904187acb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c896114a87f2d4d95b3e6b260a56a8b588b14c9b0f70b95566bc10a1e5a74a4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d8fee26350067211d64f389a66bb0838f25bbbf566b803ea3987e30f53d0e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "622a9544c007a0487180fd15a8fe71d6dcbbd8f064fff241eaeed1a4ec4bc4ef"
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