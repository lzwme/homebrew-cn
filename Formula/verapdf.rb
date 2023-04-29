class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.200.tar.gz"
  sha256 "002d0dc3071cc21b0ecb622972cd4e059e2a972a53a03371ad9ff8d5966f7bce"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8931cc645e7b446827d1bdab86dfb5be3e0b7c58b6a47135f9294f52a3fc8301"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8602d73eef14cd51f4e18d81faa361ef45a46cc15fff61ae0e574dffda7cfb24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "896ec8cbebfed3e5e04d28fb3df83835e31e2a61028bccf76b7307ebaef9da48"
    sha256 cellar: :any_skip_relocation, ventura:        "a4825c7f7a19ece4be0360b8ed059507bf2e0e7d78e9be58fd05c2dbebe08705"
    sha256 cellar: :any_skip_relocation, monterey:       "c7d7b27b82821a6625f8cc548693a680ab93b2559e954224f0e73691a361f003"
    sha256 cellar: :any_skip_relocation, big_sur:        "88d4d94a63fc584773563ad6f0c3e6022ae1b260bc76298a9eb21958ee5a6a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3dcabad0c14f6e5e855dd6a65318ba3e382a65a80536389f768bc426269114a"
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