class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.172.tar.gz"
  sha256 "1ca908b8de7f28c74b220882f8b53f64937f27aeddb1e8c65ea7a5c6b5d92acb"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "930fcf1fc029fed678cde2b12f1e761ea4218f043d31992f1906760e68bbd815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "551dec6d1b23621840e95ad4aa1f23fefe15715bc301ff735b7f91f256ed51c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "511f784db225ba9ccd13cdfb31e91260cef9512f054a156c640d4c785d8de88b"
    sha256 cellar: :any_skip_relocation, ventura:        "051d6c3071ee363081c46e504e4afdcc366e400437864a7fa4e8e056e9f6852c"
    sha256 cellar: :any_skip_relocation, monterey:       "f644d0c51e16186bdf9a6741cd43076665ddc7e437c7430fa248bb228716e386"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eaaec02a26349d965783ba88aa83e26f8b7ef3b654e1928af3cd1ff00c0c0bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d735af87a4e218dd02e6a4672d16c3ed60214ff742ae2503dcc7955cd88728e2"
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