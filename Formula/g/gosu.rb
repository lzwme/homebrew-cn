class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https:gosu-lang.github.io"
  url "https:github.comgosu-langgosu-langarchiverefstagsv1.18.5.tar.gz"
  sha256 "d3996d30fb3084190ace32f8a30ee6343c4d74e4e74f13078c24d03d2f4695df"
  license "Apache-2.0"
  head "https:github.comgosu-langgosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40f58d976da9281ff19334d0dc5aaa1c924904ceac1bd458d21b5ce5db68709a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "378b87a84955305fcae6225dd3afd339b372f9fb906aba9db1ab0e23cd6015f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3ed6b8d340d4e14adfee9e50c139d33083f06bc58aad8deedce37313a2f1869"
    sha256 cellar: :any_skip_relocation, sonoma:        "4526d3b2e5d5ef7e5fa198688868895d5dbee706534f4e264f960092f7b30911"
    sha256 cellar: :any_skip_relocation, ventura:       "10efc1ecb37a89c123a36a61a5289d1297b57177e6df627c6efc646165ddc112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01d6c20a39a98660d7622e16bf45e407c651f6fea50b47dc650e9bac8b0f4d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d69ce54c12bf5340a5263e4087f7912f7161551f6a0ea51dc9658c3c38f0460f"
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