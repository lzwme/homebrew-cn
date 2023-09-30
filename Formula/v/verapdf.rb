class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.62.tar.gz"
  sha256 "78d13ab3ed9102667ad6d328f33890e2e964d42b692f1f7ba6704af23e566acb"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a83847510fe5d20bd7afc4f409279ac1e64a0656943a583b3d3835727e5a7fcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a1f32d9d9d75242500f332ee1995b9bb22dd63fe9de8a4a72738fe6ad97b300"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31eb0556bb303a1d0ef93db8f9fb90bf40e4483758ae9fd3b54834df5d9a3e23"
    sha256 cellar: :any_skip_relocation, sonoma:         "719561721d6585dc826b027ddb647a3f8549428d05c5e87cd539d51e4942ebb1"
    sha256 cellar: :any_skip_relocation, ventura:        "b3cd5d8520f6adfb6a10e1a17b498874279782ca5e8bbabf1eab542dbc028394"
    sha256 cellar: :any_skip_relocation, monterey:       "995086da37de900f6ece7fd2c382bc9b14e5866d97838176b3e1cd77f40dd868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9abe78593d69fc39a42fcb7d7a20f22d28cdc3e0652cf4c5b2bd973b85638732"
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