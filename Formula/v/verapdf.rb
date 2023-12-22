class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.158.tar.gz"
  sha256 "7716514251baa749705abfb71fc2ab91c29d93306ad6101003754b9b04b05390"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eaa1d9b631951a754ae8709f0ff105a5269ae3f6f8f5af968fa6610ff7226637"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29fd3a4cbd6664287da720dddfaa962e564c12f9c296e12fba57c1c4f27b1f9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9d0768af716e5821debe943aff80fdd21a307b856105971526c10b9c5f82748"
    sha256 cellar: :any_skip_relocation, sonoma:         "c242940031f14fe11cc464e4a32d3778643b4247dc256b49c56a2b64cf10d2da"
    sha256 cellar: :any_skip_relocation, ventura:        "14b7beb4a6202069c7bfb0b79b0b4a785ef9ad7003c6b04693229ae1b7a139a1"
    sha256 cellar: :any_skip_relocation, monterey:       "3d594b9cfd4a43a313619bb95d099a7918e86899e07f077b66ee51b3f8127fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0163407600099798f3a71f2ce833783f1ccbafb2ba00fb25abfca188eaf258da"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "clean", "install"

    installer_file = Pathname.glob("installertargetverapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec"verapdf", libexec"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("17")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}verapdf", NO_CD: "1") do
      system prefix"testsexit-status.sh"
    end
  end
end