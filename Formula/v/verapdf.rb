class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.159.tar.gz"
  sha256 "9a90fe2af2df7230fa30cb673585a7789ce4f1617baf0cd26c4bc516e46cff80"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d67e7db05d51115274d1f29983b545d831425ae4b6c28d47c8e5ef95e7f0609"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c6806bcf0a59f695b31dc23e4079317c79ebc953eb160c8a523c9223ea8d6bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2359fbdbe82ac3cc2f17d7a239ec7d307a94f0af0f5c06116d1af50d2123806"
    sha256 cellar: :any_skip_relocation, sonoma:         "aae36a976d6eed6bb180c17e6c72d9a52ee835872f3cf86fdd872155c0f0a4b2"
    sha256 cellar: :any_skip_relocation, ventura:        "45ebaf311701a2a94ca5ea9d16d683f33fee44eeac46509e339e571ec7c95708"
    sha256 cellar: :any_skip_relocation, monterey:       "91f8bf8cef3b3ec45ed3ed5674cc77ae0c846e02c5816bdc272ac4392185ad31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e79c8f9bf7bceccf78c04dedcb9b2fffd34de971f7278132785a3bde4e2a98ab"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "clean", "install"

    installer_file = Pathname.glob("installertargetverapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec"verapdf", libexec"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("17")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}verapdf", NO_CD: "1") do
      system prefix"testsexit-status.sh"
    end
  end
end