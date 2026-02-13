class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://ghfast.top/https://github.com/idursun/jjui/archive/refs/tags/v0.9.11.tar.gz"
  sha256 "8245ee2e2691060ffdfb210b0b64f2165090e3925fc907b7a938ef665388e75c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77ec001ec7a7d3854ed71c29336b3ae009e4f353de2fcca37438a56218dd2ee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77ec001ec7a7d3854ed71c29336b3ae009e4f353de2fcca37438a56218dd2ee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77ec001ec7a7d3854ed71c29336b3ae009e4f353de2fcca37438a56218dd2ee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d90684dc17282031ba7d7ef3c707376545889964bea51276a050bb8e11a3c57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75e9f3baddaf0e4c8eb93cbffb35db757b7f22fb06a85d09d2ef9b7148b6bee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f28250a358cb7a41030a58be2655d0e1e707ad78ecdeace12a6ad8093a25b4db"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end