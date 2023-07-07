class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.12.tar.gz"
  sha256 "cd1a9be942f72b8e385f474c3038ef1138df5caddf4bd201afd94cfa026663a7"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9441074d9d24391415cb3c629a730efeecd71af24b052387291c99cca642143c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "264d713d8124bd1024aafdc465ed09da437f87052f96453fcd9bbad99ecf9c77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d4c7bcf35c08ebdef938aca8ece67405dc716908bfe9b238bfd509366e8776c"
    sha256 cellar: :any_skip_relocation, ventura:        "8fba74758982e332f21ef28a888200e622b32e180098fd7e0a37ce9fd1504b5d"
    sha256 cellar: :any_skip_relocation, monterey:       "3d992f871b511624c2e02abbd6de1f438931ac15bfcfad9cebc5e8073034d6a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f89a31e6ff5ec67a6ce3bf29aa5ea5ba00c490b512a939157fa9448026b52add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f1e5a528f69076f72956497173b75d5cdbc529d49fa46c45482847ad0e1713b"
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