class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://ghfast.top/https://github.com/flix/flix/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "ea5a0489d82d7c25c5fc73e52d207b6a78ed5f8313dcbdc00291ed634232ad27"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac9c48e49655df3dbbbed59d202579ab406ba7899486eb369ead8d85e742e127"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd48fbbdf98aeca14b264eb2ea8c0d7c37f952c9d149bc7dcd16a0277a049085"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59368c7c3da4b1e5494ac92ab65cb2ae580a840dd129b1490bb15b1e259c8352"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb23dc2888c39aad98c096f87a8f70744a5c808f7e27a2b9994c6dfa19f36f99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9096322e98d3ea0fe95072dd67eadbc4e9723a8b2ac525f54538ccac40b975ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cef18c8e9926b4b34213dbf1a3ae4bc147adef62a319cfd2f360a8cf985b109"
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