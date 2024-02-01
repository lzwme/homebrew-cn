class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.183.tar.gz"
  sha256 "77945fec3e6c0b3714c77707ae854c701de88cc5fbb1b606edd4751e3750e161"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0674ca18e59f675b2b499c7ee12a4507159f2f5cdefa1be702284eb567c6bfd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fd94485579ebf533301ec0f4d84347d494f42816ea9432f69ed7e09489b5e2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c92bed14312e3b44557df230104fa2e4958804cdacdf55d555677efe449feeb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "62b2114bec497d3840cf2b20b5ce9246986bf16f899480c9a7fba1a44e16bbd8"
    sha256 cellar: :any_skip_relocation, ventura:        "9e2a5b188077cb4e574613cdadef76af604094e1301ef79d9827a4545281e302"
    sha256 cellar: :any_skip_relocation, monterey:       "017c73af6725f5f970a86a4978007ca8aaa7aa2eb6de63de2977be507a8ca69d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c940ca23b61b59c23f0e139fe6d58b4749fea1fc1c781a643cb821484ad55c64"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "mvn", "clean", "install", "-DskipTests"

    installer_file = Pathname.glob("installertargetverapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec"verapdf", libexec"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}verapdf", NO_CD: "1") do
      system prefix"testsexit-status.sh"
    end
  end
end