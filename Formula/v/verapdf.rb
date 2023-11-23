class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.108.tar.gz"
  sha256 "49051bcf3418e9e17de50f2d422a83c013e5d21467e5924ea9705d51fc2f172b"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a7eb3f9708588987feadf756ca98b5461a689c8fd7686ecaeace6ec2b90d5a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "407bca9c173454f7dc5d6231d5fd1bb591b0d2ef4f11b1019e3bd4ca360a8c34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0de9d336c25fb9465ed07f1cadb89dc64491d17564fca65698343ac4abad673a"
    sha256 cellar: :any_skip_relocation, sonoma:         "77b56a39fdf2c58b1f6d980679ee3007e446db50abd90912f858db51373c61aa"
    sha256 cellar: :any_skip_relocation, ventura:        "b3af5b3ae40af6939448d54e5a1f839eb4099c4d594a2e3b9cc89b9b0a6c6728"
    sha256 cellar: :any_skip_relocation, monterey:       "75597dfdf5c85a105b2e09b7366f34024b4c01920586d151a02b3b5390c9bf69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a57626d2d63e5ed7e7e25264ce5e5b062d00757e940c0962f2ab77dea465383a"
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