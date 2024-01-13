class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https:gosu-lang.github.io"
  url "https:github.comgosu-langgosu-langarchiverefstagsv1.17.7.tar.gz"
  sha256 "949ecc45587531a0bf13208e53dfbf6d363190c6a27d19acaefe7e70b3434bca"
  license "Apache-2.0"
  head "https:github.comgosu-langgosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67e5aa19eedb58b7e7eedc73b61bba06db526b1e3a92d505b6b9e207d5c2ef5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "255ec6f5d8925ce62019216c63458347424ec8c84a73de0a15f772d01a1d0189"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ca94fadae9603dbdc43eb07640b1e8f34784d1e4744f344498b8f797ab4f3ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "242a7a279d27b351fb60236be33f7cc74e4884e7fb7af27b9f31883cb5603f8e"
    sha256 cellar: :any_skip_relocation, ventura:        "b29ae8f66f213243600aeb722c6656e04917f7105cfdb39e6bf9b7243437296e"
    sha256 cellar: :any_skip_relocation, monterey:       "bf0df76ba00b5e48197c971d4927651ee516d644bb4547adb07cca157dec9665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d3f25158a2ed007445524f93f828352cad56188d4ec2881022f865f9941b6b"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  skip_clean "libexecext"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")

    system "mvn", "package"
    libexec.install Dir["gosutargetgosu-#{version}-fullgosu-#{version}*"]
    (libexec"ext").mkpath
    (bin"gosu").write_env_script libexec"bingosu", Language::Java.java_home_env("11")
  end

  test do
    (testpath"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}gosu test.gsp").chomp
  end
end