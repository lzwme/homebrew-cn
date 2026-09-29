class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://ghfast.top/https://github.com/flix/flix/archive/refs/tags/v0.77.0.tar.gz"
  sha256 "9152e8a42e271c5120a60ff7f6a85c1e7bcb01c435d434494a581605356481d5"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "831a70101b583dccbf582e9292333afa6d28a144b27db9a10f75ef903d427b10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ede84659705a51f25552ea773213eab591c79ba6f3224d09edc0345a2fa7b81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c5c1e9b8ffad0200c8ce7053bfee620bfb98ea7c36e3ecffe8c962f4f3190042"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8af000c9c0a10febd74678db5140ef791d0dc0064e1572e88daebde747820c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8982b3adb109c3cd3d668b4c53a4c9f710a70405d7c8ec61f5b649492b8d8501"
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