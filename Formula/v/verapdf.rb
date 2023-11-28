class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.112.tar.gz"
  sha256 "50e49acdf819c3817915ed76e4804525f8a356ba257235f88868d90c943dbad1"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd371fa922c5255a3867d359fc26e35699cbfe2efb483be2e8135108f8b795f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3650e1cb4778a1735be7c4a1e51fc2282b233f16f07205d5cf0fbddc4cb24169"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eeca325bf8b3a7e72863d77eb39aa7dcaf5ee471a6a57453bf8cd87407ff23b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8d50e7a57912e9756b617afae83917c7ed7117cde2ef42acb80822de852dfa6"
    sha256 cellar: :any_skip_relocation, ventura:        "b8a1d2ca9b998b0e285b87d5dce0edc91b8788e688855be1f4d7cf50b7c8f785"
    sha256 cellar: :any_skip_relocation, monterey:       "07b1df0383b26a07aff08ea126c30683eb2321e5d4d0d97e5eb05e4efcc96922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36ac87ad37126c23f998bedf3624cd011fb0b1ff60ffaea01dbb49845d21f031"
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