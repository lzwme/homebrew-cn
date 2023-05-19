class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.215.tar.gz"
  sha256 "d8fc0183aac33beb86992d4dedb5fbc4926562a7b6ace0cac393d8380e933c4d"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc07cb96db47240cbecf5b75c2008fb6981db325156386d26848abad79b6be60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb1a82771d2d6e3a012c302ddf09c5de71cfe65adfa859df4fdfce451fb17274"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14dbf80ab90ac8a71d0730ae8d962a6284dacb003899bb2abe609082e0ec7192"
    sha256 cellar: :any_skip_relocation, ventura:        "669707213e834d0ce2afaee2177839bf32d9e3bc6712f9d156495c6424e5fa9c"
    sha256 cellar: :any_skip_relocation, monterey:       "e7711f06b77ce4d8bc5c47f94f26d7696a776b47c4ab175983cc8149724f5df4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a71bc59a349a61589ec14e7ddfcbc7fa62fa3a26deeda2c636cd6d54c7492090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d78c56f156b35f67a16d20d758d784fcc2edd20c4e452d31e04706752bfb4817"
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