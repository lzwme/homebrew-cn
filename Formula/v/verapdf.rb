class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.247.tar.gz"
  sha256 "1f4ad52e541532b669a411d3b5441e0fe67597fa32e62df368b258dc77291927"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac726cfb166e233cfd3a57c8c2ac200d06147526f9fb8a36006f9b18ccc1cd03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63520451afc7e8617caa4769670126e09d496548a4561321484d602ef1ec517c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c895499c25d0503fa26d41e2fdc6231350e3116d39a8b8009a27e2277256f2c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1f696147146cf1dfad8ef856c940520cb45a1862485d49b0c5c557fffa5e507"
    sha256 cellar: :any_skip_relocation, ventura:        "7f9cb876e5b73eca65283a3fb866aaa598a1dc4a05eb169ca5249334bfc44e5a"
    sha256 cellar: :any_skip_relocation, monterey:       "5b325c7b69314b264e50041d6612999dfce27e8b3990fb74de4fb6c3c0c24354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3bcb915a249c470ab0f412caa70a16135d7740aa2e643f131fa3bcef5fc3bb1"
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