class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://ghfast.top/https://github.com/toitlang/jaguar/archive/refs/tags/v1.70.0.tar.gz"
  sha256 "72149d045f03492f317cc119738b6bae0d4f390d1ba9d645816d24b1bcd5fe1e"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da59974f41ed386c8d5e184939761e0b543b6af1d47083879c53ebc57a8bdf38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da59974f41ed386c8d5e184939761e0b543b6af1d47083879c53ebc57a8bdf38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da59974f41ed386c8d5e184939761e0b543b6af1d47083879c53ebc57a8bdf38"
    sha256 cellar: :any_skip_relocation, sonoma:        "d26486a6f533975ddd1fa7f5defa41f3310fcddc84b7df92c75c150f7ae1b0eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d353b74e274707e1ae1fec09ff30621b318de57a37cf628f785dca3de45da685"
    sha256 cellar: :any,                 x86_64_linux:  "425824c248c9e04f24372f430bd717761117d1b9bbaca2676799b2f36db289b4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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