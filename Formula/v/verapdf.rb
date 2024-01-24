class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.173.tar.gz"
  sha256 "93e7fceee4cb2307401962a6317f1087bc337740ace535850c2f37b1bf3e7998"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d66f24a4243d173c700885df55396bdb9fad1e4534490cd38575863770a9540"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "628b3649be9324238dc9774d448ff6bdcaa35187e5d04fc6498a1ce8aedee4f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6a548322eb873bf952f69db039162806a917d0976eaafbc889b6959849a4ec4"
    sha256 cellar: :any_skip_relocation, sonoma:         "da082387348a9b50dfea7c7e824d3d3e6e7d9327b4575aa7df63891c903b8f21"
    sha256 cellar: :any_skip_relocation, ventura:        "ebec6223c020e44d5e2855daf36695a4a0bffeb5fa36dd933e7a07280f88cb9f"
    sha256 cellar: :any_skip_relocation, monterey:       "453a59072212866b2a20e64daa07d19609842a82bb722b09de7626d5ef188483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cba77e39704023002b5df584df88915e7ef4f97b6549f4e5d1107b16ffc2cbe0"
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