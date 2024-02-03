class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.187.tar.gz"
  sha256 "bf756655d0af0a4ed95851c629efa8dd5b18ec02a81e49c6de80a12fa3413aa3"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d3bec40d44b440eaa6f82eb8a65f69fcdf7e6a98cb1d1f2b2128d4dc12be3b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ef4f089522f3fc773365393aef138d2e43cb866f0ac962f13404974dfe38ed7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb4f746623997fd807e8253962a83241f12706b40c2e7403a8a60ff428f4bfb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ac6245fb0acb7d1d869e49101f2636d1c950c90d39d3521bdcaa147171b8f90"
    sha256 cellar: :any_skip_relocation, ventura:        "e381785f88bbba9fc4569c2c38e908992a373f6460945dd0b4c37a15e907cfd0"
    sha256 cellar: :any_skip_relocation, monterey:       "eace1c9b660b89da8fbf131c26634d64640fe3e6bda9056fff56ec647857dfc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc1edb2d26dcf071f3bb1548b679fe2799aaee1be2af569b7b13d53b808d2692"
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