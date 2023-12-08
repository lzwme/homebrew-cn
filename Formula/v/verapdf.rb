class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.128.tar.gz"
  sha256 "1c4edabba334ec82888cf2fdd309c4a39c42721dc350017a2ba131d63729655e"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e4288d9c1b8a94c3c1cafcbaea6a82b17c589b31b3c324ad305d4d798f1ceed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efee50d22d54f0885755f33037ca74d701289aaa47fccd6b4e48d5286e578737"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4e72b2f1e50c743c222084b041136e018d1ddc5b0c0afb6a22296ee20058bbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "5416f85a4a0737acf81ce1a3ff23b3b2c6057ebc67b37e65f9d0c4a6ff4ac92a"
    sha256 cellar: :any_skip_relocation, ventura:        "e758275bbf258bcd70ce5a456d8f2cfd708bb6f1819c26be6baeec731a45710a"
    sha256 cellar: :any_skip_relocation, monterey:       "ed542f81db3cc6fe7c941b28aacf8d7e17b62b109fa9443bf674343c6477f2c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c81f77ee1f7e26d880b9a84779ecebe829dc95892dcfc2b048eeca7a9b4c2f12"
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