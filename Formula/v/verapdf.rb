class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.185.tar.gz"
  sha256 "66b079abc06928030922514209787365ad83beb8a23ceb4556961f75832e445f"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1e32d6cc22e3eb4578a67e4487c67079868058aa65e44f8d0e03051fd98a177"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e88daee8bc1cda898999d1111946fbb0943d24630747557cda2ddffd4ae2e521"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdbd716b527d87e5d793902f37bab46effbd42182ce49cba5ddc522b0560ab79"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f8928ecb45fe9dced5d8e5c3472d7e8d1ccff6083608c8174ca09f300d43f6c"
    sha256 cellar: :any_skip_relocation, ventura:        "b6ed96ee59ee9dfc6a821ea83e6953ecb6fd9a84d9156272930fab69778d098f"
    sha256 cellar: :any_skip_relocation, monterey:       "a9906b5db06ed35ea66d50f01303f2d3f02301eba18d5190bf31df2281f5e718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441f1435fd92dfafd51210a4b4e02b2dff595c4f97f2587c25168bb0de4fd30a"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "mvn", "clean", "install", "-DskipTests"

    installer_file = Pathname.glob("installertargetverapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec"verapdf", libexec"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}verapdf", NO_CD: "1") do
      system prefix"testsexit-status.sh"
    end
  end
end