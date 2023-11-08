class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.101.tar.gz"
  sha256 "b2a4edce4dfffa04c1452e5c2ec1c8c107a006f07bdaa8b476d2b91800f69b79"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86945c41eedd74f78e9d0f1cb5f30663e3449b7347bfab5e62b07bf07d9a104d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87506d21bf8f26d9d1ecb61b6d25c22723dc93e6490d9a248b6027b6d0707db5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6026f58070abfd27aef568cd37edf4ae72bbdbcba9c457d5ceab8d1f99752425"
    sha256 cellar: :any_skip_relocation, sonoma:         "02fb7ce01b00b5e40f213ffdcc9945df9ad8c6a3e56d0cdcdbb80c4887a2ecc7"
    sha256 cellar: :any_skip_relocation, ventura:        "2705556520c7c8c1fd9ba88fcb28b7365a3fe588155520a37ff169aa58ecfd4c"
    sha256 cellar: :any_skip_relocation, monterey:       "08f6741bafbb2fbbd4e028c61bdf3df52691b2d681804aca9af3e54ec77f7501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8caec6e24a12d792e60a2d8f0249c47baadce2c8a74ff5b63bda367774abcc43"
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