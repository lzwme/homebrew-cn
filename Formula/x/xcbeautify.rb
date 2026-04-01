class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://ghfast.top/https://github.com/cpisciotta/xcbeautify/archive/refs/tags/3.1.5.tar.gz"
  sha256 "ed08cbdf18bfb283f0ddae2ec9a6f582ba158dbb5bbc9876021dee66e3366734"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1df6afda8d93fd806d9dbbea25cbeee28710674b8ecb25f24e8d17ffdf33911a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cd2b139573273e6203d3475b17f74ea0187fad336f2650caede4d0d0080d1f5"
    sha256 cellar: :any,                 arm64_sonoma:  "55b9f4871edf688eaf7a4b4e81ff6e5d994cfcf3a7a159689c922783e2cc48df"
    sha256 cellar: :any,                 sonoma:        "83330a87b930f46baf4b552d8b7fb025583438fd9f0c97b74980fee6c6f366e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da665810f3608d7d065deb2d044310879988538f4979e00106306a253e45eeef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4db5ae28d1a0a03fac6b4e4c373aefb3098e67efe967e21cd8a1e415ff9318d"
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