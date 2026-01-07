class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.71.tar.gz"
  sha256 "f57e98b958394e8a31be1b1f3a1e543886f316c18e1a0b142aab8949827f24dd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c422c9a376ba00dc08e9b5a9086b13cf6ab1438acb6368943a9e34f4a3812f3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0559c77c7847fb98478fd6617bece15abb1e46b6ea71d80c17a24192337d32c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a6dfe044c313584e5222491526960e1ef32cda89ea5ef5a55f7d0663ffee108"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa88013829f2d4826d5d118e205b0c800bd6bbfb5f279a62e92b6313a1614ee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91a3c083c7c33a314ab27e348c9febfdee1487e0745eaf423e1012ce875f220a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b5c69dd69b229502ef45380227a49e29863f5bfb8393cb04f7c05eef152a13"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    # Test script mode: type text, save, and quit
    commands = <<~JSON
      {"type":"type_text","text":"Hello from Homebrew"}
      {"type":"key","code":"s","modifiers":["ctrl"]}
      {"type":"quit"}
    JSON

    pipe_output("#{bin}/fresh --no-session test.txt --log-file fresh.log", commands)
    log_output = (testpath/"fresh.log").read.gsub(/\e\[\d+(;\d+)?m/, "")
    assert_match "INFO fresh: Editor starting", log_output
  end
end