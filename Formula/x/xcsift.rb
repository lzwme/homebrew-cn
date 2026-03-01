class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://ghfast.top/https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "0e627158aaa53eeec08885ebf35306703066fca06bf8d27ed06043611d30086f"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34194ac982d3311bc02e7ffd6844e75317550d8fc36530d617b920851b76f00a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e71c10afb6b4c86a9479654f32c880483e985c3f179acac5856f7450de737426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2c3bba6303330e85cc86dabbb6860f2b99b61e515f40b6f22bca454d1ab77e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "251deed623338b81ca6078f3636b2d911acf44abb0e213eaeee8b155410b26a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c34fb9db04fb43f1f9d32a5416565c29409026c1e625edfcbc460f975d8e371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "961b046b80215d4591f8d32b7b9273749187d509c5a045a1dc594ee136162430"
  end

  depends_on xcode: ["16.0", :build]
  uses_from_macos "swift" => :build, since: :sonoma

  def install
    inreplace "Sources/main.swift", "VERSION_PLACEHOLDER", version.to_s

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end

    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end