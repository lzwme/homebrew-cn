class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://ghfast.top/https://github.com/toitlang/jaguar/archive/refs/tags/v1.69.0.tar.gz"
  sha256 "6aeb83fbe5dff381d3d4e090343032c223766a74b8efcd9ccfb68b87b6f9bf3b"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "338ae95f2c91a360340a1c8ce6a842c2401cc08fd3d8aba5db62f7d25f93d247"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "338ae95f2c91a360340a1c8ce6a842c2401cc08fd3d8aba5db62f7d25f93d247"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "338ae95f2c91a360340a1c8ce6a842c2401cc08fd3d8aba5db62f7d25f93d247"
    sha256 cellar: :any_skip_relocation, sonoma:        "e93ebc27efc648e268cf0bc647908641d9cc675fbe9f3c5bd81e6abd1459feb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bd5047f35b35740991c7c8ac9077d348326f207485c3ebc6ffea42dd97dd6cb"
    sha256 cellar: :any,                 x86_64_linux:  "ca84f57703dd3d35cf9547a60de92155b6d751776a228fab45fde03aa3dbc257"
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