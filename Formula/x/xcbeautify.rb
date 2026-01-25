class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://ghfast.top/https://github.com/cpisciotta/xcbeautify/archive/refs/tags/3.1.3.tar.gz"
  sha256 "59f387a378707cfc3309f15cd0570da6543424e83c0ea075d7258fe2ba3e372a"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27a685de31599db0b9ad8c1b8caedae6f4db3f3a9d1c68d434f39b76ee3c1c07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ba201ecb60d7b03d3208f2ddc7b8b1cecb8637801e2dcb129607b28805dff86"
    sha256 cellar: :any,                 arm64_sonoma:  "2c496b39ba5a5af2398d5d724a496fac00b816cf0de7e6c9fcb2cbe57f39f115"
    sha256 cellar: :any,                 sonoma:        "0cf7284daee3df17c210b15f0bbdf2e8bee751591b256297b0b68df1eeb06a1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d63c4a2757d744cc21f004f68f951aead36f87943c69855b5ea11d0b67bf3d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f14b5de5e60fb3e70bf23f5b45464b0f4cc5b04fe11655ca2cba14d72fb66cb"
  end

  # needs Swift tools version 6.1.0
  uses_from_macos "swift" => :build, since: :sequoia
  uses_from_macos "libxml2"

  on_sequoia do
    # Workaround for https://github.com/apple/swift-argument-parser/issues/827
    # Conditional should really be Swift >= 6.2 but not available so using
    # a check on the specific ld version included with Xcode >= 26
    depends_on xcode: :build if DevelopmentTools.ld64_version >= "1221.4"
  end

  def install
    args = if OS.mac?
      %w[--disable-sandbox]
    else
      %w[--static-swift-stdlib -Xswiftc -use-ld=ld]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/xcbeautify"
    generate_completions_from_executable(bin/"xcbeautify", "--generate-completion-script")
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[MyApp] Compiling Main.storyboard",
      pipe_output("#{bin}/xcbeautify --disable-colored-output", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end