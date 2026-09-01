class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://ghfast.top/https://github.com/hahwul/dalfox/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "c66e1fffc4c3294bd4081df6817f22facca94cd2fda84161acb4717c8a6d8c7e"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b26bcbd7350b308b3a69664406cfab35feb004e3f557065dfc2be1a3e8202dcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a742187f832e8289ea93c52a6d71c53519a47f0a27268dc59b232e65171330b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac5b328045e460d3fd1008d000fb86814421d334bb267f9ced4d44f201c19036"
    sha256 cellar: :any,                 arm64_linux:   "c47cb01749ebb60321664cbacedf2ef469e3569f217e65083a2cfdc69260dd42"
    sha256 cellar: :any,                 x86_64_linux:  "e96bb9b6c573970a16917aa3e7ffced70cffb38199b10935c8797ddd78980918"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox -V 2>&1")

    url = "https://pentest-ground.com:4280/vulnerabilities/xss_r/"
    output = shell_output("#{bin}/dalfox scan \"#{url}\" 2>&1", 1)
    assert_match "scan completed", output
  end
end