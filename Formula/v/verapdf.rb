class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.48.tar.gz"
  sha256 "0aa94a68d0f9c711d5adcfc7215f45d5ba5d5bb2e970555663d23b0f1f55d503"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd55d83330dbd9e6d85e8573d92398cc36f5623cf4b3d1a3790d1387d39b0705"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f61b471e9b27918e64a2fe438ff90509b48673d4ae1ab693e4461a2490ed2642"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f31e0a2167e39a1d239a394b4006080a56cc4c650d8c14769f4e7f02d66c803"
    sha256 cellar: :any_skip_relocation, ventura:        "425b5413b1f6b87ffab6c588af72e376ca843e0dd3be7ee376d325753da865a3"
    sha256 cellar: :any_skip_relocation, monterey:       "a6bcfe434e8e4757f6438387069355a416241d3968bf8afb12bf2df24edcff8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "07f0ff48b48d3ccfcd3be8843eb54f11411ed82a559c533e1e5f86ea8500c6ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a10180723334361c067887d26a394d44cb2fdce64b3399785603d4a777a70f13"
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