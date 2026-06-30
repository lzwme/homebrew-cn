class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://ghfast.top/https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.14.0.tar.gz"
  sha256 "15551cf280b6262a573f4818d641aa8c526a1558efb2b40f4fc20e7805481a90"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4fdc3cdf8eab0dcfe662d594f4357c4e18ea13db4a9bcd982df83abb91f21ca"
    sha256 cellar: :any,                 arm64_sequoia: "7b0a591a0b8d2198ab01ef5c3f86e021f86626d05bb8113473f4af4de686825b"
    sha256 cellar: :any,                 arm64_sonoma:  "1f72cb70711b3a789f3b9cfb49a9eafa2771aaabb5cc0ba80ddf7ff2d48a7718"
    sha256 cellar: :any,                 sonoma:        "8360393c9042d301845237c9aaa06574cff160ab580f01898e0b40a0498d0f2c"
    sha256 cellar: :any,                 arm64_linux:   "1ee904df97a63a4feb1d0aba9ec6a7471bb3b4663bf7d0d4d7691c504a328860"
    sha256 cellar: :any,                 x86_64_linux:  "515e7204de302fa9bdf4960ac64880810fd258acdfe0f0e1693aac64405d4598"
  end

  uses_from_macos "swift" => :build, since: :tahoe # swift 6.2+
  uses_from_macos "curl"

  def install
    inreplace "Sources/SwiftOutdated/SwiftOutdated.swift", "dev", version.to_s

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xlinker", "-L#{formula_opt_lib("curl")}"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/swift-outdated"
    generate_completions_from_executable(bin/"swift-outdated", "--generate-completion-script")
  end

  test do
    assert_match "No Package.resolved found", shell_output("#{bin}/swift-outdated 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/swift-outdated --version")
  end
end