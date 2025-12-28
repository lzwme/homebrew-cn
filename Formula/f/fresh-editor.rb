class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.65.tar.gz"
  sha256 "27b59cf8df28dd472d6f498abd524438d0b027faf3c3c65be2702a2b7c458d21"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d3a9a2d2ec3ca5795031541082bbfeb836423537f94469b5d7673991f13107c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9603e9f27debdf6d4e8b5dd4eb897d40d0b587402e1f0678bd0b7ece030deb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f410b166bf01e7a649bc21342a2ff3f199a8cb4e14e3381e1583aec70fc4fa17"
    sha256 cellar: :any_skip_relocation, sonoma:        "b37c644d1ad0964362fc243d84a6a4d5652dddb46b9813695e4ebbc850a9af97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0ece5f90260388a70a68703426aa33de823f9346b3175d51eb95d875fa21bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f06284c80f91375d26d208ad1d52f3ef1de92aa9952367b2a3ee9873df469c"
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