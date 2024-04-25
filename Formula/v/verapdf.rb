class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.251.tar.gz"
  sha256 "8a4f2559de6aa6a214502582330a38f0f9033679d012a824c0d4d243e9204140"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b92aae2e943867909218a0ab54fa9a0dd59e0451b07c26dd832b51b9a1f5e2e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3a0e267f5b459761da56a50cd50d0f87bee48c78ea2270ef8bce69ebd078dab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b380eda903dbb8f7fe444456da208da0fe3a56a7ed477c3c02860a753fa4b2c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fa9c796c11943557aefb5918f01f8f86c5f8620c2eafe03ff0eb871753a2663"
    sha256 cellar: :any_skip_relocation, ventura:        "64fdabdb952c071dd1c27ec945c1a081172ca38ffe6ed059410f4f53b1a51266"
    sha256 cellar: :any_skip_relocation, monterey:       "b703cf8031a1ad70a4c6cee422665c0eaa973a95691f77be4b1b020bfb2b0ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "737033d8cf16198aaf40b4cafbd3e290ff7ae5461f3fdebd1db9e10bba11fa2b"
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