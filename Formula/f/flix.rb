class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https:flix.dev"
  url "https:github.comflixflixarchiverefstagsv0.43.0.tar.gz"
  sha256 "1b0b609c7be59d0d69a664a3e545568be06dfdcedfa813689c939040846e50e0"
  license "Apache-2.0"
  head "https:github.comflixflix.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?\.?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "faab0ee7b777b90f36a08f4dfb1a258c01a5359b23cf40f1b394fb16163fb78a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec419e0fd1dac35236e4e258d13d841b91e9b2531685b855a47754cc7514253c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3992e2cea9c103d2d91f30fe04aab0a207b2efb7d36c9f6dfceee863d9b79c63"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd4c329ced40c49a64e0d1ef41eb5c8b7b8ba7a2ca16e3b073a4f586ee9b1c11"
    sha256 cellar: :any_skip_relocation, ventura:        "92c8b44ffa95fb8fc6c7a0b7817c15700bcc0663ac439d52c872ceb181afaf62"
    sha256 cellar: :any_skip_relocation, monterey:       "78a791551cfe25472f1687d9e869236aaaee6a2bb398dccaf63ef65bedd05942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8c52ffb09641c75219a0491229eab00cda07d8664399230251b2b3b692406ef"
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