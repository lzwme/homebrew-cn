class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.163.tar.gz"
  sha256 "eac3001660e4bb1e36a7f59a828f6887de4dfb436a1230b467331ffd5aaa650e"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b56f72b6c79201edd0d837a226859b08eee5ce1fdd28f9e0cdd471a7c4713d8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5207088f7049f7b5e86fd25c4c9bd2538f27d1b3cb6430cf9931698b09c54848"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf2525c9d140fe40d897098640f310a67770f8596ea464f0f7f2567e59dcb189"
    sha256 cellar: :any_skip_relocation, ventura:        "41df5c74dae55133e32fb1b5769967f37c6c920e05ded00a2441e725719270e7"
    sha256 cellar: :any_skip_relocation, monterey:       "fdcc244f54b8ab9f72aa49d78fad989f5b66f5871bc2cecfcfc7a8b1ecbd14e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3917d2352815e59b7c373b0ffe0027de82d8530e1828bfb88c381fe36614a49a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9329c4ea24afe74a6fa2c404120d2bdbecaef67258ded6c5980efbd30d17999b"
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