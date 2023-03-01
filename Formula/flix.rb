class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://ghproxy.com/https://github.com/flix/flix/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "437293fce5f401587f0ebbcea743781627869c1363727deb8e36a206daab373a"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd1908131c8e3c5acd1845ba2b0e21ec0c2ee220d9274b2335038688d9e2b296"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e874be50191d4db0d2899007b810284f785d4c1f9d5902f76cb57c6519e62cc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab017cdd20c4d7871191cfe24dfdf6f925452a72328852f52c70729d094e4b87"
    sha256 cellar: :any_skip_relocation, ventura:        "3afdf1ea1f8c672f53c2b25b8d503b55bc1778cd5d1dd66c72b0ff1b78e0f601"
    sha256 cellar: :any_skip_relocation, monterey:       "55f5b4fe2d1ad356a1ee9122f923c6ce811ada766b0990902b7d6a74ab572ef8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a610f73a366538a8d2b8404d5c86c3b37693332da44e2e9c0096d92151747406"
    sha256 cellar: :any_skip_relocation, catalina:       "a1ce694f41aec6c11379c1953080b2f7849fe67f701bbe8a8aee9c0c331fa913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1384d92519febc995bd9bc6a9a21f4dd2f854536e30cc53b3c4221cc7e250066"
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