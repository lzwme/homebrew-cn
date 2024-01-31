class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.180.tar.gz"
  sha256 "e5b1a2d63e627ea27c038aa4fe7442faa6415427006c3d5042297cce64b913ba"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10b9942bece9edf675d86bc35f43472e47222b3fd2a769781988951dca8ae858"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7a4a245a3d0a6addd3d5989e070ebecbc4dcd90830ceada10ac323b813b9fcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "696d5c04048832fca62262be4dadcae803258ed5ea719c1d296b36d41d3ad2eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa06f126c586c36182a9ae310e6f0c89e886a62a3087212f0b04c417ac763a4a"
    sha256 cellar: :any_skip_relocation, ventura:        "a7f8d02ac199bce6b6be2f1c79aa59444568f72ea38c3f4a522f8ad856976db8"
    sha256 cellar: :any_skip_relocation, monterey:       "9a08d037be1ab13d2b6cb10868062e5d5bb853ab3f89150149ec9a7f33c0b81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b5476ac5391c702c5670423455bd9a94508c29761fb5ce7e9e4ce14b69bac7"
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