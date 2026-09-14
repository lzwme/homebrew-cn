class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://ghfast.top/https://github.com/flix/flix/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "5f5c9f63b95211870ea5edd29510be26196313d017bf8ed31796ece4633b9b0e"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c4f5707d197263f63eb72ba425ca4cb5be067ddd9af4f302ae3fa6ffb43a50c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69febd94b9e4eb1f1a6c1966864a0aeb13f248471b15ea7a55dd64abd393a4dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4965b112fc2d60ea01a00f8d644baa408ef96f261cbe4868b27d58f786dcba63"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f75c7f772f4e0ea5ae822e3a89729267a9c27bd94b13f14006cc06697f88f3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e90de9a0bc957d54e8e802eeb9e9e45cac6be1695648f8babdd00f0b26c6f453"
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