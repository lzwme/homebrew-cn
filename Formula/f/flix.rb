class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://ghfast.top/https://github.com/flix/flix/archive/refs/tags/v0.75.2.tar.gz"
  sha256 "28a0ee553281905509fa70f319d677462e427c1b2dee66558d7f6b10a49c7164"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73349d34d38094d9febccac2acfe6f84b7cb047a4ac28f8c539c40fd6927749f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54e2a70d7db4ac24d3f4067fbcfea3b11332c7cf2a3e7c71fb9d7b2eefedd5c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "310256a1cc7a7cc3a98c4e3d26a2561512afa7d4a8025ee8f31d7dfd7bd8b83d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f6eeceaf2ec0326866f308ea57653ee33916a053f7f49d5bf47bf1dbc6a8fda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2e467186704f78b49a0f71bc7ceb802c1a0f66c85c171e9ea50c21209cfdbba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4428020132f5f896c52d51bc136f4a02e87e42c31bf4f3a1e667b39d84b324f"
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