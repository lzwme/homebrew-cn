class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.86.tar.gz"
  sha256 "32553dd395e1776eb37eb77ee8768b37ef3ae1c9d3a1af33864f9a446cb23970"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11781ffee7751bdfadb204162c4e26f414919208308e886dcc14f0eb338b59fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64d7235621b8ffe3529430b7577a7ad020b53444a423c629d21baccd38852c70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8ce65c8f77290782e97ef55c03447ed7ad6c19000d835064ea0cf8a72c8886b"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd6337582f838bdf7c57b2702917d53fcbae280c859abd80d4f176afa9383fbe"
    sha256 cellar: :any_skip_relocation, ventura:        "91e1aa42f5b62a076c20841580e021af1d798d0479747ebda326a9e30adad5c0"
    sha256 cellar: :any_skip_relocation, monterey:       "072c9c9aa54408158ec3d81ee4ecc96c4914d8fb08a3ec924c797b5880195115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecf6710221a307d7dbae471b9185c16b02dacf5151671938b8e68ac62a29da87"
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