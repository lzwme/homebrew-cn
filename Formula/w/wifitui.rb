class Wifitui < Formula
  desc "Fast featureful friendly wifi terminal UI"
  homepage "https://github.com/shazow/wifitui"
  url "https://ghfast.top/https://github.com/shazow/wifitui/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "4d2d8ea402c61837d94145c10dc5d64366dbfbc862747d49f993bb41803c3711"
  license "MIT"
  head "https://github.com/shazow/wifitui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7252f3f920eb9d5d0f522dce6595113e83709a08f37c7df92db31c10457dd882"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7252f3f920eb9d5d0f522dce6595113e83709a08f37c7df92db31c10457dd882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7252f3f920eb9d5d0f522dce6595113e83709a08f37c7df92db31c10457dd882"
    sha256 cellar: :any_skip_relocation, sonoma:        "64e84affd1239c9407cfba7eec1ce33aa882aadde829317ccccb3b6b5a16386c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b76d56a97fc054265ce89a763b7b74600f4b4cfa5e691118cb85c8d5adc00cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ad3b58d0b545dd0012a0d62f423241b5741e9ac24942e1d6c7e233494f021a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wifitui --version")

    expected = if OS.mac?
      "no Wi-Fi interface found"
    else
      "error: dial unix /var/run/dbus/system_bus_socket: connect: no such file or directory"
    end

    assert_match expected, shell_output("#{bin}/wifitui show nonexistent_network_id 2>&1", 1)
  end
end