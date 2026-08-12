class Av1an < Formula
  desc "Cross-platform command-line encoding framework"
  homepage "https://github.com/rust-av/Av1an"
  license "GPL-3.0-only"
  revision 2
  head "https://github.com/rust-av/Av1an.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/rust-av/Av1an/archive/refs/tags/v0.5.2.tar.gz"
    sha256 "58eba4215ffaf07a58065e78fb4aec8df9ebda48e9d996621d559f3024b3538b"

    # Workaround for VapourSynth 74+ until new release
    patch :DATA
  end

  # Differentiate v-prefixed tags from old version schemes
  livecheck do
    url :stable
    regex(/^v(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fe39b03d44ab8ea709e74b0a025799e378ac8ee0b887997050da2ddcf3c36a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5703c8154d5d8456048b22401c0b5de715afbe5b597af423b3f2bc98ee628b12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50ae3bf46bd4ae35d3fd6cbe0a27853e8c85b04ec10bbcd03723ee33c6574111"
    sha256 cellar: :any_skip_relocation, sonoma:        "4482d4bcacb71192138c0259c28ceb101cb119e87c3ae0a4a5d12b967250b22d"
    sha256 cellar: :any,                 arm64_linux:   "4c83ef03746c3d256b2cf8ce20902ec8e6c24afe84f48c052fd2a7d25f41013a"
    sha256 cellar: :any,                 x86_64_linux:  "26a5b533f84a2c7f34bd05f032e1f63da4f76576a67b6fbb33f2d3a6b0a11188"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "mkvtoolnix"
  depends_on "vapoursynth"

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    ENV["VERGEN_GIT_COMMIT_DATE"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args(path: "av1an")

    generate_completions_from_executable(bin/"av1an", "--completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/av1an --version")

    cp test_fixtures("test.mp4"), testpath
    system bin/"av1an", "-i", testpath/"test.mp4", "-o", testpath/"test.av1.mkv"
    assert_path_exists testpath/"test.av1.mkv"
  end
end

__END__
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1030,6 +1030,16 @@ dependencies = [
  "pkg-config",
 ]
 
+[[package]]
+name = "libloading"
+version = "0.9.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "754ca22de805bb5744484a5b151a9e1a8e837d5dc232c2d7d8c2e3492edc8b60"
+dependencies = [
+ "cfg-if",
+ "windows-link 0.2.1",
+]
+
 [[package]]
 name = "libz-sys"
 version = "1.1.23"
@@ -2042,9 +2052,9 @@ checksum = "ba73ea9cf16a25df0c8caa16c51acb937d5712a8429db78a3ee29d5dcacd3a65"
 
 [[package]]
 name = "vapoursynth"
-version = "0.5.1"
+version = "0.5.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f817dd2eca0813092eecb84c916acef69419da39ee8563d9aeb25118bc927a71"
+checksum = "413b994d9955202f99298ef502dec6d84f1be7603483d19158a365f9fdb8f128"
 dependencies = [
  "anyhow",
  "thiserror",
@@ -2053,9 +2063,12 @@ dependencies = [
 
 [[package]]
 name = "vapoursynth-sys"
-version = "0.5.0"
+version = "0.6.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0dc01f455bc7ef73678bbcab5332fbe745892fa9466ccefe086de52a32fbce19"
+checksum = "4ef47dc5817613dbe0251eadbe2cea0443edebbb3a551be7b6728314ff44e12e"
+dependencies = [
+ "libloading",
+]
 
 [[package]]
 name = "vcpkg"