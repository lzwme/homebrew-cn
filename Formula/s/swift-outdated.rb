class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://ghfast.top/https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.15.2.tar.gz"
  sha256 "5ca2620e750497dc1f145e95ad8142b3289c6d2223203e57d8f40bb68b07e281"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93bcc6d207c3cabc0a005fe985f95b75ef5574368c3a5ec916c0b638507afa35"
    sha256 cellar: :any,                 arm64_sequoia: "0875fbb1bad318029320e65426b86d251a8bce6069c4572f4d95ec21b34e37fc"
    sha256 cellar: :any,                 arm64_sonoma:  "14932968b5cd3e169c91d31330e6cf05c7e118f986d2fee10a03ec5eb8a7fbec"
    sha256 cellar: :any,                 sonoma:        "a677b163aaafbb1ba9fa65640bf3c03b2fa70a316c892c21ae8f48b91334b3af"
    sha256 cellar: :any,                 arm64_linux:   "c37ea4de85c011218354549e15d003c88fbfe457048fba48d9fbc01821710664"
    sha256 cellar: :any,                 x86_64_linux:  "162cbd18b29152be9f6494bc517826a9e0ad419b9a049d1dd1219d9ded12536c"
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