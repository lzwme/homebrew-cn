class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.249.tar.gz"
  sha256 "5601e367004a96d869665ccf1e45ba29b802863c5d5f156552c3b10f34fddaf9"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "405a73c8238f0f5f025e77cb0eb64586e3f418aab108e81a9f9e5cbc3925b56f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6398933eef9818483bd8b71caf4cc1225afb676943ae5ee06c3942513502fa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "113d5178aff820cde462d01f9e9782f88864fa352382ba2e164056ae6407be7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "49653b067a36af5829638a5983424f5c05df06fe75269ca3b80732b5c04e9151"
    sha256 cellar: :any_skip_relocation, ventura:        "45777863077d6e3584e802041a36e700e90c6df07c986a98bb54b2d0324809e0"
    sha256 cellar: :any_skip_relocation, monterey:       "e9450594afcd64fc900f2845b5822ebd48fee230f95c2d5184605cb79858c022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8745efba68c0a2d7e50eb02b7790b41a3d0adc94855b3a765205f2be0d220b0b"
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