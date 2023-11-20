class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://ghproxy.com/https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.17.4.tar.gz"
  sha256 "654eaa32121b39419cc67ba1c4c5208df00fddb85fe36de8f3d81cb1a400c661"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0af26744cd30f6a5f126e57d44d387d6b1ecd4f8888bd085e1ba15fe1a3537d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7e16aac5f5be76b993a8c612b1237d4c1bf92d4d8436c6f1ad7743ca719a95d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b1b4c9a4ca6946ede289c36f6a8a3818695fd0307db4e505fe5eada2d3c89cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "4497b08237c2235453e945fbce1a63bb9ee02ec712b903a8874fe6f977dca311"
    sha256 cellar: :any_skip_relocation, ventura:        "835c9051702602159e86752f02626ba7d60b1231e8fb1fdba872c7f76b5cc819"
    sha256 cellar: :any_skip_relocation, monterey:       "72927e9f2b1a8d90ae2c91d571ff5c9e23b8eb0058089793fe7af02da6bbfdb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a37dfccec4f82cae16a83256149f998c4dc145ab6f488afe47337cdfd43c5c59"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  skip_clean "libexec/ext"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    (bin/"gosu").write_env_script libexec/"bin/gosu", Language::Java.java_home_env("11")
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end