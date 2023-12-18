class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https:gosu-lang.github.io"
  url "https:github.comgosu-langgosu-langarchiverefstagsv1.17.5.tar.gz"
  sha256 "123f7034a24f0640388a4e344c3cd5247b17e82c3442a6416c102decb16ad575"
  license "Apache-2.0"
  head "https:github.comgosu-langgosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f1a03b2c52e8615cc7ff60c6069eafa2f2a5cf8c7f63ad3fad5f47cf9975ae4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4f9b8b8fd26e84335886c2f8fcd98980ee8f4cc7f5b2ed858f2b04575edf9b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a0b657c635ca6786e684a12789e109f2adfd2e0918b9bc0cb0bd73489cb2863"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfaa679babc1ece4a4ef9a6db3523c45f0b463991f07111b2514e24bad0fa414"
    sha256 cellar: :any_skip_relocation, ventura:        "d88f301068b3cfd2c836876d424353b3a66df1cc99d7ae9b0726391a53b86cd0"
    sha256 cellar: :any_skip_relocation, monterey:       "f96998ae7916724406784d78f8aee16fbe9aceb2ad52b7166a1deddc07ea0e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "801ee14a4f407d521427ee85581b35c910a7f6c9ce6ac5a077811f83f9ccd828"
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