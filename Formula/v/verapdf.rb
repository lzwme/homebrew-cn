class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.110.tar.gz"
  sha256 "df86a5bc4a1c00576381e10f96f56cb1e13138a6b500710473c2aaefe00b899c"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8768228ebb3b71daea00ad56963f4639d917829b5155952cd238aeec1de53606"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25e808ceaf88a11685210a1a98a7aa1dcce3c804b72c45e2bc9cb2747d9e487e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "493af9ee0c56439c26a223eab7b7cefbc0095b31e85bbf4753fcddaa90041128"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f03c8f479c053cb0ecf8706c5d4407bbbb4ab2c653b85f701cfbc144710da3d"
    sha256 cellar: :any_skip_relocation, ventura:        "ab91ea11b32c2958783b9632cefc92aa03a5d2acc83235734ba2d67e8b0db83c"
    sha256 cellar: :any_skip_relocation, monterey:       "7d6caaa7b7e8311ebf8dbecd0b79045ff0dae39c44f0cab4eb1bc651212bd0f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd15f043d5027830b5209d6d947713397c13f66e547daa4e06757b84540081b7"
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