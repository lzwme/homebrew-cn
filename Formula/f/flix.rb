class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://ghproxy.com/https://github.com/flix/flix/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "e1582dceca206898bb3776d6d7c5e1a0a377da51871691fb5a3e861782eb9003"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "355f34174ba849cb6a1cb9d95194fd3b6880a083d695ea8ae0f7a77b1522f5eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "385fb9f76da569403aa988a34e5107ae0f25ddd64a3a9d5a2c8b99dd619861bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6603e51725a85f17c0dfa721fc1897ce874f64d3f3a3f727ad28cdeaee68fac2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2ef0b4924a354203458a789b810df41c1078e1898bf03fc590c532d66226ca1"
    sha256 cellar: :any_skip_relocation, ventura:        "c06c5e018862383979b5ea5d03e6dda3e4cb52363d0f1a754306fc0ad9da2c20"
    sha256 cellar: :any_skip_relocation, monterey:       "c49ecf2451ca13049ca6dccfaa53805d0e9aeb53e96794286170346594a5b539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd03efa4689ea7e0842ba0c213865b1b59a9e461c4ced7032da4d79d7d15928c"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    system Formula["gradle"].bin/"gradle", "build", "jar"
    prefix.install "build/libs/flix-#{version}.jar"
    bin.write_jar_script prefix/"flix-#{version}.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}/flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}/flix test 2>&1")
  end
end