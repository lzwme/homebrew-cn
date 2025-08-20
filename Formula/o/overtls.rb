class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://ghfast.top/https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "8a80b5905b5af0f492f53f328dab5525f40f94009c649ea36a17ad2c15e93d65"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e73a57048f43410eeaac739cb73b0bf7417f733722f2ed269c8dc11a644f3f99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e9fcfaded3e3e677072646b97846da519e81734eba6b116318e9ca6eef46eb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47f7ee5d1758eb53703c926ca9cf3ed31dbb0b004f7fc96d7ee172a3806501d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c7b087233190a20a421f14445f07011cad51450b42ca16af0dfbfdac0fa4833"
    sha256 cellar: :any_skip_relocation, ventura:       "c7a51b0fd104671917b8707b3365905cfcdb0578d66b4e475b3e10e269e93aa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6074102e2a14fe5fc4a9ca7cd8f8d127bf70a354720de5a48ac41d780a8221f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fbbd0997183dc3f11dc7320fcfbf0eebb5d80f446c1549d03ef28fb051fa82b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output("#{bin}/overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end