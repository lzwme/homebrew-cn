class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/skylot/jadx"
  url "https://ghfast.top/https://github.com/skylot/jadx/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "6ae2e92532f3df58b2caf340b26ebb5502b5557a82a905d06249f69a6e9e1396"
  license "Apache-2.0"
  head "https://github.com/skylot/jadx.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "541d59a6f5ce07cb96cd9af180271ddf7a33e0b99bc9e2fca7343bfc5098209c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "541d59a6f5ce07cb96cd9af180271ddf7a33e0b99bc9e2fca7343bfc5098209c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "541d59a6f5ce07cb96cd9af180271ddf7a33e0b99bc9e2fca7343bfc5098209c"
    sha256 cellar: :any_skip_relocation, sonoma:        "541d59a6f5ce07cb96cd9af180271ddf7a33e0b99bc9e2fca7343bfc5098209c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d285501b24c38def6d142fcb016927df6a5786b83bcf34fd10fe2e85a00a7b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d285501b24c38def6d142fcb016927df6a5786b83bcf34fd10fe2e85a00a7b0"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    ENV["JADX_VERSION"] = version.to_s if build.stable?

    system "gradle", "clean", "dist"
    libexec.install Dir["build/jadx/*"]
    bin.install libexec/"bin/jadx"
    bin.install libexec/"bin/jadx-gui"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jadx --version")

    resource "homebrew-test.apk" do
      url "https://ghfast.top/https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    resource("homebrew-test.apk").stage do
      system bin/"jadx", "-d", "out", "redex-test.apk"
    end
  end
end