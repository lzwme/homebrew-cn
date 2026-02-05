class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://ghfast.top/https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "f07ae754d40568b8f8896ffe5f9dbfe785ac109178a12a1500875af28ab6d355"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4cc10ffc2949eddcc08c6cddcd17ab2d32813fc1d099f92f8c94d663a889389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc715fa5601b78551aaa31f8e0a9aa151a13243ebecdbbcac21b9f34784548e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8d1e5780c91a45c4caad4ee9b075dbd2e14d457b8ae4685615dee6e7a216f59"
    sha256 cellar: :any_skip_relocation, sonoma:        "378675fbd8aba2cc2a4daa74c9ca582daec507ecc38210e950345d1467da213a"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    inreplace "Sources/main.swift", "VERSION_PLACEHOLDER", version.to_s
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end