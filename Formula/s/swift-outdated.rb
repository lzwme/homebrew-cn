class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://ghfast.top/https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.13.0.tar.gz"
  sha256 "11f9d7f0fe15cd1e53fe812b4ed5075e61dee8adc1d87224c1f1c89e3b316728"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e79fdbd93ad0f2f736710607c9f57618de0a6390da333714206e79e71940bef"
    sha256 cellar: :any,                 arm64_sequoia: "a686f8d67f6b0046e0179ab6329dd73c25ec0f07cb09e01b1d69b55b207f270b"
    sha256 cellar: :any,                 arm64_sonoma:  "3680aca5f2ccd0980e6c60c06f48ff6a362b54ce315ca260843d4524f6e5d8aa"
    sha256 cellar: :any,                 sonoma:        "d6d2318fcd51c3d34e07b9c2691ea111c68bf59ef634be15b9a122219c3bda10"
    sha256 cellar: :any,                 arm64_linux:   "63eaa3e9f9f55902d397c499e6ddf5c92d2ab1a0c524ab1d0a9325b23feff08a"
    sha256 cellar: :any,                 x86_64_linux:  "69d5f2fb54bfa6b06f773deb74d78778ac17dda76ea81f506af8d4f81c37568d"
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