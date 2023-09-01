class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.40.tar.gz"
  sha256 "c5e415844016991a4cea9fb4bc4eea9c01704b161ae1519bbb3999ab85f8c0c2"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d6453713f4648868aaedadecde5f76b265f360b08e5a3db0155c1029543a649"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbb436fed7aacef224701f5065cef162032226105e5bd1b9495df0238749c903"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a61e3bacecc377d59eb8b0eb185880adb3a20180d4258ced7e4d9adeb0dfb112"
    sha256 cellar: :any_skip_relocation, ventura:        "7a9096372e59cf4853b6af6260a74a88c27f560a4a5dbad7dd6cf2bbf7dc18dc"
    sha256 cellar: :any_skip_relocation, monterey:       "15149f97be07cba72abe68a8d19d1e3ea268aca7dfa0f4d87f956de28359efc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "881670404c8cab7b4f517c718648060ee05264966180447b6e98dc8d05801309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f01545fafce51fa6f465a0bf585861c9735d1a35e6be028a6fed18868af3832"
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