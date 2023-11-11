class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.104.tar.gz"
  sha256 "e41ba9f8e2b2761f040755692eacc958ec16954b4843e7597f577946e483f59a"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b56a9b2131965ed2e9547684c5c7b946d6b26673f789eb3074bd663f85dad106"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06438bbb161f09955210ff07e420c16b3b880ec3c5e70bfa3dd78579441e3a9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "096192a134b82164ebc131f7838946a87c80bac8e144d319523c6021e7690645"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e51072bf78f844f032b4a312ab76956ca4672f973dea3eb8fba0cce06dc22d9"
    sha256 cellar: :any_skip_relocation, ventura:        "30bff60495c00bbb223de473b352aab203511a73148da71c03dd6fdcefd11647"
    sha256 cellar: :any_skip_relocation, monterey:       "6f320a5edd1905051143afce349f752d66c232335c8330ffca7baf808091cea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ba84d3453fc95e657716154f059f74a6aa696208fd6cbfb4cf00bcf27d8c518"
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