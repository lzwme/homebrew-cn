class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.161.tar.gz"
  sha256 "b5c9348e15058b275d233a5a5c33958bd8b2b54f866ef1765e74a1e12e72b316"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5357bc4ea056369f1d0cf9e9fc1f6ac632410406e1e702ef7dc3c47d9702f878"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d338ee6997c599f856b8e61de40d5c4ac8e2b00149c95da636ea02e2f03abb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba07e05084402a8a579ebe8b66e8e571d6f9c31fcae5df014aa166921c8e89cd"
    sha256 cellar: :any_skip_relocation, ventura:        "d596061f985ebefb93a7bb9ad8b4b7ea439248c93a8da1e349f544163e97716a"
    sha256 cellar: :any_skip_relocation, monterey:       "4926670e8701fc6ac0cff5c2755395a435bb1e4fbb717b8c72b896af2ed986d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f39c83c1e4cd986783a02d0449c24205e8d9933565bdcfa6faf154bcd753f76f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "439d6db869bc385582e31d7d54538b1aa127c3e90e7ec668412f5b010119efc4"
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