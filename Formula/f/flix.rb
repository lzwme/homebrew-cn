class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https:flix.dev"
  url "https:github.comflixflixarchiverefstagsv0.44.0.tar.gz"
  sha256 "2443339bb905af91324991d131c9790a7c77299f346ce2494911e8e5d50b1632"
  license "Apache-2.0"
  head "https:github.comflixflix.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?\.?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a217518dc3aa216c669e7176b1904d518fbe8ad8a9d73567e556fc982a8fdce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83d80760a4c797fc54f5150b636ed4b9188ab586a910f94b79eef5ae191dc1d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b7162309273967ace152b429658b2817f3b8f7abcdd56ffde10038a3f209862"
    sha256 cellar: :any_skip_relocation, sonoma:         "0607066dbb5c8fe9a25097ff07311e76e5816f7ca0da2dba53a6f54d45b73917"
    sha256 cellar: :any_skip_relocation, ventura:        "01410405dd0b7324a4270a364dc8eaac55236d67df80ae503df395bd3f0e5ad9"
    sha256 cellar: :any_skip_relocation, monterey:       "1949c5450362b4117e617b0ebfc4ca28dd609dd95e437647ab6356d5ab1224d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35c3d0c8a042c766f1ff76195a2355e64c27ab338f4c8e2f486a46d284fd39cf"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    system Formula["gradle"].bin"gradle", "build", "jar"
    prefix.install "buildlibsflix-#{version}.jar"
    bin.write_jar_script prefix"flix-#{version}.jar", "flix"
  end

  test do
    system bin"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}flix test 2>&1")
  end
end