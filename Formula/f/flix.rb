class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://ghfast.top/https://github.com/flix/flix/archive/refs/tags/v0.76.1.tar.gz"
  sha256 "b6c5df339f4e136dd6e02a091fe0828cf497574994e7f0062e96ec3cec54e024"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7dfaa890e81219f6bdc2101a6293a6e2921b5216197ccf0085a3830005c5b63c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c76f15dc2c8579912c5145c1e58f82f56e01d91f9df297ec455eb5b2b1256b23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "40d5bb8742ca5afbcf38289d8d8a317e80ee10fa33191e2c71d21ce076b95e05"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ceae6e7dba94f4b233bc1addcad4d60b217d1cf98a77f99c76062430ad12ed79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e51d6f1923c4515cef82c35fe84d7eba32901016278c294f789f8a9c73f5ad83"
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