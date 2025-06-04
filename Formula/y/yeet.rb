class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https:github.comTecharoHQyeet"
  url "https:github.comTecharoHQyeetarchiverefstagsv0.6.1.tar.gz"
  sha256 "dcd0199495e5cbe9dded07ffe0ed4b86acb44a6d9d43998425ffef7fcc188d7e"
  license "MIT"
  head "https:github.comTecharoHQyeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adce749755dbd9fa70914a9060dfb69baa356f28d7e880f505b7a629f641916d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adce749755dbd9fa70914a9060dfb69baa356f28d7e880f505b7a629f641916d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adce749755dbd9fa70914a9060dfb69baa356f28d7e880f505b7a629f641916d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fe5a7dac77da8778f27e48ffe3364a043fb5a005a66a900c84d5463b41b463e"
    sha256 cellar: :any_skip_relocation, ventura:       "5fe5a7dac77da8778f27e48ffe3364a043fb5a005a66a900c84d5463b41b463e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7b8fe20a7ceaeecd202b89c9841840b79300865461fe61cb7659cf91f27924a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comTecharoHQyeet.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdyeet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}yeet -version")

    output = "open yeetfile.js: no such file or directory"
    assert_match output, shell_output("#{bin}yeet 2>&1", 1)
  end
end