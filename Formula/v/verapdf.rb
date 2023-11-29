class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.113.tar.gz"
  sha256 "13ef5ff74589711d2e6a6ff24d173c59e14c7a33d18c29419ac1747bde8522d0"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2206f1928bf38d2e454970f704467ade1f19d8466b9c8228792efdfe447c96be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2b1e3b1b97fe6918b6239c5b2d39f8f74222ffabe9d293a3a4db3c0578098dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e98170f0b6e34c0df4c9b30b550a7ba2e03690a67da609625a7f01cbca0bfff2"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfc73684dcddba4241481fb6c9529ff5fb0a1970f9a1fad6808ea5e0c42e7651"
    sha256 cellar: :any_skip_relocation, ventura:        "c14ed85f3eb82c29968e95e12d4dae1469757bf4b92c6690c8b15c91bc763709"
    sha256 cellar: :any_skip_relocation, monterey:       "1f1f9c929d9c2e311be65113e0e72c4cf47e6119ff5f9215e70525b1a0d33bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83fafa5c8c01cd7591d9ca54aa08637a6ab9da23047bd765e79b259739124678"
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