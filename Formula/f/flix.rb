class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https:flix.dev"
  url "https:github.comflixflixarchiverefstagsv0.58.0.tar.gz"
  sha256 "bed452f6e0b679c97b3895b49f78786fed7b51579e3f18ec587756d21354d6b4"
  license "Apache-2.0"
  head "https:github.comflixflix.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?\.?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab536dc2a5c24a8d544dae65d7095cadd06b7f7e462ba9c9b171ac559e32fd05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "851aac69e9442d0b9825dde09df1d4ae817e383bc4e2a464878e8a5fa732f9d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5354acd4b6b5422044a2cef183e6f6cea374528b07e2e00482c533ca47bfb972"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8bd8b5f2269677df42211c6c2b6568ff0c523e62ef2bf7b951b8200bfd632a9"
    sha256 cellar: :any_skip_relocation, ventura:       "7dad4d4e7d3a52e5131b78dad8a99c1027c3d138de25de5bd779f5b172830a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cca4126b09d0f5435b3a606ec1af03a31d872f026df8bb2e812b92acc9bf120c"
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