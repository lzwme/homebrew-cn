class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://ghfast.top/https://github.com/flix/flix/archive/refs/tags/v0.73.0.tar.gz"
  sha256 "e75cac293f587faf41a353ad4f36d85b4ad24077e5b1f844a35918bb2623e073"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d99adb41a17819201fb979dfa36bb9d19d8524ec4cc52ed2590bf19af679d1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "089442152d3e24bdb90ec9e871d8c7b4f898be774b610cba09caa73037d5ce2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c1a6a32b82b71289e5b2393c6ba1bd73468277633b23153865753dd00f113d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f6a07e41e59c05e7897305c245aa8ea5ff0738912bac660ba78e8c8a10197bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d4fd400e7f20e982b8af41347f190b7e521ce0a2a90b52bb077eb5b6337bc92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baad7c29101d020fb99c3c96c12d09c38e17321c8f3f33b10ffab16bb7c82f84"
  end

  depends_on "mill" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "mill", "--no-daemon", "flix.compile"
    system "mill", "--no-daemon", "flix.assembly"
    libexec.install "out/flix/assembly.dest/out.jar" => "flix.jar"
    bin.write_jar_script libexec/"flix.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}/flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}/flix test 2>&1")
  end
end