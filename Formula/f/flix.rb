class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https:flix.dev"
  url "https:github.comflixflixarchiverefstagsv0.55.0.tar.gz"
  sha256 "ec28d37fa610ad62f668a0fc9811321f15f3529ac0bf50230340ea8e3f1a933e"
  license "Apache-2.0"
  head "https:github.comflixflix.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?\.?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff26e65e8ada1881a5df4a22542927945cc9bba62fa689a9cf9b9ff8dd038862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0796dd943754a680ebf7547b7a1747b05375a272029f74305dce01307267f990"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "131646f157e7aab229ee9be10a1793bc87a6f7c24339d4eff464846fe3726745"
    sha256 cellar: :any_skip_relocation, sonoma:        "60e802d9935139689db72f1df02f626b70ef6181f6c60a54ac876119f3d9a4f1"
    sha256 cellar: :any_skip_relocation, ventura:       "c223da610a010f3db8cb5063e0d603de4fb4c65fc000aee78e6d8916e5249634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19699b17ab835e07dd0f3c9c8fa882aff368c8ac0c2f57d8db817bb7285e909b"
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