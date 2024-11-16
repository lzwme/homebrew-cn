class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https:flix.dev"
  url "https:github.comflixflixarchiverefstagsv0.53.0.tar.gz"
  sha256 "aef423948fe2afc9a743d81edbb85b3b4e2acf1d293b438e502b10741fad772e"
  license "Apache-2.0"
  head "https:github.comflixflix.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?\.?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cfadf68cb4d1e0ef5cc350b1842a09ee120800eb57f9135243bab06894633dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f1b2dd099277c2fb2996545d65b52acd95ffc795dd1a9facd13b5d22a1050d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aaca50d00f4eefc5b96d8942dea1864060d0ed0f2aa998b38a707749e2a7a452"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3d571e1c8626ef37655c0daa0d32e76736ce69d82ef99a86520c2f85139d2ae"
    sha256 cellar: :any_skip_relocation, ventura:       "db19de8f46072de194cae14fdff44ac68df63ce4ee56f8ff5c81c3a4058e8090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f13824984ee3f127d729b9274f42973dda4c03ca40846e5ebfd227867f956d5e"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system Formula["gradle"].bin"gradle", "--no-daemon", "build", "jar"
    prefix.install "buildlibsflix-#{version}.jar"
    bin.write_jar_script prefix"flix-#{version}.jar", "flix", java_version: "21"
  end

  test do
    system bin"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}flix test 2>&1")
  end
end