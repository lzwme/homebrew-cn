class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://ghfast.top/https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.15.0.tar.gz"
  sha256 "1b44f8be65f80dbdf6de561955c046cfec761eb7bb8ca49415d4a4c0885540b3"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb313eeadd4e164b7e8a571e32e75a70c37a399c47eed6cd4970ef4fdfc5ebce"
    sha256 cellar: :any,                 arm64_sequoia: "6d0cc07ebcb69b57b44e1f3c6af29657c4b65a88aadb9d4d6360e1f444dd8319"
    sha256 cellar: :any,                 arm64_sonoma:  "2a649b0896a383a43f629d72d2f8ba2e7056be400b7fa4a618f4e6cfda1bb01d"
    sha256 cellar: :any,                 sonoma:        "1cb7157a259d05c6087c27cd4cb1b639f5b7f9dc55de9befed8a52562878a1a6"
    sha256 cellar: :any,                 arm64_linux:   "27b5d0fbe1e2c087fef8e38151b20680580d89b22db3c7ed10b19685c2f8062b"
    sha256 cellar: :any,                 x86_64_linux:  "03418c47e8dcef38a0d88ac6549d12a98ffaabc34988317fea62a4dae9576ca5"
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