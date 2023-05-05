class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://ghproxy.com/https://github.com/flix/flix/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "434de658781ace5926b32e3ab6ee2608aadddce5aaa4679b97fa2a39c8371411"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35f34329fab8e6b4aeea4fa957085fc7ae12b7f53e143b0d6e5cfede69394106"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e63312a04025cf1a7c49419178f57660ca8e3cc05a75776b9a2c1ab6a4fabe82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87c5f7bbc0854d797149007478b3130fb6eeb5275ad130be3486211bc822ee2d"
    sha256 cellar: :any_skip_relocation, ventura:        "0de8056b33140d633fa6ca3bce0e104bc388ca65963fded5ee45c10164bfae46"
    sha256 cellar: :any_skip_relocation, monterey:       "7ea8687c89f5d5866364a260be8e956433dfd6165a20fd1823cc9d73cc99b572"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f4255474e1f63152d51817106cebee0d486227be240aaa6b6f48fede67974e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e557f1175cbc4add8ed6fe0b549d1778b4978ea53a846dd70d442d37bfdd44bd"
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
    assert_match "Hello World!", shell_output("#{bin/"flix"} run")
    assert_match "Running 1 tests...", shell_output("#{bin/"flix"} test")
  end
end