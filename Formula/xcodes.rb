class Xcodes < Formula
  desc "Best command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/XcodesOrg/xcodes"
  url "https://ghfast.top/https://github.com/nicerloop/xcodes/archive/refs/heads/fix-universal.tar.gz"
  version "1.6.2-universal"
  sha256 "2f99e1d93104239f06792a968e3e45aceb752b5001ab56697ea1b3669d70bf20"
  license "MIT"

  depends_on xcode: ["13.3", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcodes"
    generate_completions_from_executable(bin/"xcodes", "--generate-completion-script")
  end

  test do
    assert_match "1.0", shell_output("#{bin}/xcodes list")
  end
end