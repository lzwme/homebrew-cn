class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https:flix.dev"
  url "https:github.comflixflixarchiverefstagsv0.54.0.tar.gz"
  sha256 "e763af61df0787268b4010d9fe68be803bcce7db8ec5af37255a69c6e9a7f888"
  license "Apache-2.0"
  head "https:github.comflixflix.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?\.?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d042c85f5cf5e22e8926cb5ac217133b7116367a0cb3c29c7f0c6686e62ecca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "874a48053a18123ef60e010c88badb274cf557854e571f62aab40af48038bfbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5f0964ab36ab4c662a0264d372703a52bb0a768e4ddf1cc5172a398154c367e"
    sha256 cellar: :any_skip_relocation, sonoma:        "345095dcaf6f69911023d6d643a9f8fcc1b26c88f307a3728f77fe9b51469b3f"
    sha256 cellar: :any_skip_relocation, ventura:       "bde3869ad1e73ded023c7a17d8f56123cbb7e256fdcc0ee1e27e02a109ca5faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fd117129f6cad6ac50db9fe61cfd7dccbc5ce11266c3aa8a2ef90121251f668"
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