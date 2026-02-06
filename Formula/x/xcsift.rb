class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://ghfast.top/https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "f07ae754d40568b8f8896ffe5f9dbfe785ac109178a12a1500875af28ab6d355"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cecacb38c47e680eb3cd07ef68e0c9ee8b29d3f7e153ccdda76fe2bc15715c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05962e142dad7e027f496559071cd386ccd4708f913252501dccbb84568d6d8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ad92b8818047d5b864c4f7e9fbba493be4dff1475e6c86fc88d0be815f2420c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d639cb4b3bf635f7e6bb0a3d781f49ae4781ba66833470375fc6d95cb8edb5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d421a457742cc4cb516c8b213a0e5fbf3eb251638ec91132bdb49aaa928f9e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33380253e900964e29fe8ca637f94512f32658ee7a34ff9529cf6088843d20f2"
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