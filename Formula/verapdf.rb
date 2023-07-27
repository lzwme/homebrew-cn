class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.29.tar.gz"
  sha256 "a2868b345165d32fb27f87c27b8263f9c46d5bf7ce29c1ff2b162a17c9073a2d"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce2cbb0c1db828c96717602c30d9029df3e3e93a101582d9d9157b0c1b675c30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff16184dedc0aa14f90f4a4f12ffb39d8c915c2fa2b69ac71b63ccda711c0cae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b637dc477026ac2167da7f0e121db722dca54665da96c8ee41fa4328f4d22bfd"
    sha256 cellar: :any_skip_relocation, ventura:        "0b6f22f8e5eb209e81b38d017266dda8d5a5363adb461a748acaee714b5cd903"
    sha256 cellar: :any_skip_relocation, monterey:       "a91c1fbab0e7e086c0a134ecc8d5d36c2defedad90092c5a18d1d4984dfc0b58"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b9805034c0735776ad2a384cde5cd99de88290557d266db4c867fb389ebd84e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aa5ba3debf185ed1bb5ba216535be81031cb8b4cbb850943241149fdd9a73a1"
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