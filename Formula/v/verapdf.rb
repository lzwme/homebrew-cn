class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.59.tar.gz"
  sha256 "a91db42fc30934b04a99da6e06ae09974f9a1391781d2c3616874158f2d75659"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d53484d795dc77f37daf52e49d5b2a3ec00aa360c25a6c12706d955a4203068"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90c22d100dc47938d1959a80c5236c693a34d2f604548893b4d1be1b3728d71f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3ecfb1a4d828ce4ba40b74e3716d24e4b115d3a9758269a8e6a794b9b852066"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7c9014409cb3cc084b137495c8818d688504b878088f53275ff7d5a6e9c8336"
    sha256 cellar: :any_skip_relocation, ventura:        "c93b84f15d4ebf4590b9ecd05dd2af8d28cedc3b77d81d2aa478bfe4a43f2c2b"
    sha256 cellar: :any_skip_relocation, monterey:       "e8a96b64a65dfffe31887c2b85c1c49ac09e16aa235f3afb242f5c1a611cd348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "154e686cf36ac46b8ed344dee65aa688808f33faf68210492b1d179025731d01"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "clean", "install"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("17")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}/verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end