class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://ghfast.top/https://github.com/toitlang/jaguar/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "3b94d57fa545a3ec727a5157b5732f4543760b082c3e1cd2ae0fe3f16beb41dd"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "676c12d74c266b304d61f89d3d61a87c5cdae8a8367c3e84602dec880ef2cfab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "676c12d74c266b304d61f89d3d61a87c5cdae8a8367c3e84602dec880ef2cfab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "676c12d74c266b304d61f89d3d61a87c5cdae8a8367c3e84602dec880ef2cfab"
    sha256 cellar: :any_skip_relocation, sonoma:        "996b03eb216c731db33f3170b3d423e7dcbbd6e435684a57cd8622b3ef3654a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e26f31e0d22455c8b8ce173fe23e5b6465a821fa3c26665e4ff6e11b609b25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e132c1f3f9e0a0f09136cff38862e28c56fd4ea1464911ead40b33362f5db80"
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