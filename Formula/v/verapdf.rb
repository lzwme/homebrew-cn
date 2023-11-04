class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.99.tar.gz"
  sha256 "8c0db787db43fe03d66847669afa32511df69911005a213644eea3cdcba91bcf"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff94bce5511a1c8f82fac01167649d8e647ff8da8862d0c2c997aa6d6a1cc321"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05e14d77f640b1ed82683dcbcc15321cab5b4a25d7db7016eb1674144492d05d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea9304ca7e45559397ae004a32f7fa5e439c0d43b416cb43f9bb66da29ecdc91"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cc2baf929f1684cb4a480bb90234179eacd430c4d1b6ce6a3f336af26a1f632"
    sha256 cellar: :any_skip_relocation, ventura:        "aac3f47d176894d5f05f92831dd1f6c9bf56d44801226d9dc122a0fa7e448180"
    sha256 cellar: :any_skip_relocation, monterey:       "bb4c266a8a0f26698c5183e018ea77040fff813a6f29c965e73695d5649bdc03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d08139ccb8ac25dc5dc358391ed12efbec1340c243ad25a4c6310bdcb8b87cc2"
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