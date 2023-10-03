class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.63.tar.gz"
  sha256 "1eb7146a36e6c078f722c9953408b24ef923566fc243a598adda34d76e6208b3"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "762f422b26fc3ead152d4bd5ade1ff39e24a6d40763d09849ef147ec337768ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a3f9fcde7b2c387018ba58c9c2c425e10d9bb6b17180dff27c8a2c64077ea56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee4caf3a6d92a32b93c1f09da52c0e2424f68188a8d6afdaa96d0ea926b96ece"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd4174395460a8927d11dbed139f0e8e46346965e7b6771060091f1f852823b5"
    sha256 cellar: :any_skip_relocation, ventura:        "c01457219049202444b281194381a9dbcd051a0c80bd85ed68bd9f987d63b467"
    sha256 cellar: :any_skip_relocation, monterey:       "f3af915cbdef208ab7a12250b213cf18f05a122df1d243650fda6c45213c0426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5547b15e2f3d1eeda6178d9b0427446f10a4d0c82df69ac77722391b7c4d493e"
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