class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https:flix.dev"
  url "https:github.comflixflixarchiverefstagsv0.50.0.tar.gz"
  sha256 "3126669de353a83a41b85dbc3f294e55119736d60001df225d17b495537f283b"
  license "Apache-2.0"
  head "https:github.comflixflix.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?\.?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08943e28d072efec171a6bc0183c77949153c2845c9db14578e85cb7633fa232"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5a5c538ff00829af57cbeb5030a257a1a018d8b0ba09f3879b2196a5dfafd90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9ada2c6ca109356950986513a8e5705a4f80558dbb7ca0eaecfa9061ffe69d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae22b4d454bb89f14d5563cab7c8d65a8d38bc92fcb32b9d1565bc4a430d3275"
    sha256 cellar: :any_skip_relocation, ventura:        "2ce415cd8ad3921b43d6502b56ef2681389bc26d946d4c1b69b9ba93f4d17984"
    sha256 cellar: :any_skip_relocation, monterey:       "97cf262709ae47d9a5bf87bee3b8c70aa90593deef1d1db83674b2c5d957d30b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdc1dfca3ca1143ccf371d9642523eee0cb676567c2c23b73a06ef1d7d566e10"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk@21"

  def install
    system Formula["gradle"].bin"gradle", "build", "jar"
    prefix.install "buildlibsflix-#{version}.jar"
    bin.write_jar_script prefix"flix-#{version}.jar", "flix", java_version: "21"
  end

  test do
    system bin"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}flix test 2>&1")
  end
end