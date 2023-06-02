class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.228.tar.gz"
  sha256 "298f286fd864dd63e8d00a48bd511f4eefbc0d921c892907059a9d7547d6252a"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e4a50fd39e3c5e4375de9c3c81af29bca8dfd7cd13ca08d902aab9c13d97e1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ded9660026543c372e1a814d8d6f292bbbcf1f6fb0aeb26f01326b9c386cf9c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "369c0e926028a12c023fb92018b546a3a9724b9201d2557d579c7f10bc0cc6e5"
    sha256 cellar: :any_skip_relocation, ventura:        "6352d26dcb8eb54d1f282bfa36af5d8c7a5f0744a64e3fefcafd9bce151098de"
    sha256 cellar: :any_skip_relocation, monterey:       "7fe32a9b3d9768b5a6fd762c25f7ae1895a4a741344ecce8511f11d24c5903c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "53209aec3e3d1bccfcf7b2b8c650f04288b8efca1340947354c287047f4a166c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "872677fa978c77563c5527d81bb21cf6fb8194b428170663616dffd525c91398"
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