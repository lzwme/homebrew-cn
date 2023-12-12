class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.136.tar.gz"
  sha256 "d14fed3056c71c04cc367adf2f858c5ede7cd4806dc32a21dc6e142c21640954"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53fe723f184d36e0c00399353f5b39214b5aa8db23f355d2faeaf8d8b8f4a2cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10481206688ee761d21a7c1a2be18e2c83c2a6135bd76544aade075464d5b230"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b7352885e4d046f96829d6ba877bba0d75d8578a657e5553a0112b908ad7ffa"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd40f370bb40231e5658c45a1fd1c590dcc66841e6380278fe465b6247392b2c"
    sha256 cellar: :any_skip_relocation, ventura:        "271d025efc9ac3bc4f791e584a63fef98ca65fbb413ab23ee395ab0d3530e544"
    sha256 cellar: :any_skip_relocation, monterey:       "df64d99b181ba8e2430bfb24cb65c09e20040afd469ce765e209c6f475fa1ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4211c69a9edb992d801259c68d2e3a947d9eb7a87d9edd90db52c8ad4cff2523"
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