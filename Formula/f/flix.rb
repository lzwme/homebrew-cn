class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://ghfast.top/https://github.com/flix/flix/archive/refs/tags/v0.69.1.tar.gz"
  sha256 "156cfe7c39f88f1a3e476863c0b55330ab654e11165372bb488c3b5fe0e71296"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1737c36287baaa0f276137ce6b2401f159854f3880a43a12807450aae7b4fbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c171626342fae202a03fcfc9fbd5b40eb74688087d6c4c772435304bfb5cf748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb10f3d239b1d1cd9631c7f8eb7b127e13ec53450fff65ab429a99acca69a0fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab661905f99ab506649b669330c0e63d67324e44708fefd281d59185fd098c7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ef25b46a90c7f90eefff6bf59716c8fcf42648d9bda4c0ee85f3b70879bc24c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f723382936b19e3edbb9784a995a8cd817e033aed442e268762b65350325463"
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