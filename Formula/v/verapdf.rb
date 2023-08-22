class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.36.tar.gz"
  sha256 "6af7641b5280e60a9dd99edec7cfecfcb8329beea50cdcd0150d7d922a4b2da0"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c624d21b1ca95b35f126c5df733c2f19da1860f9d85f09a9ff2e470807356a38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdf38bcf58d3201377cfb6d70460956a17edb1bb63786fc8aa4bdc05f673d478"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "331e8c8d6a81ce5e525725289a636aea623ae38f9d1d5cf56b44653dfd5af6a1"
    sha256 cellar: :any_skip_relocation, ventura:        "3d68ccc7b74fa41d7f8fe4c141439854297501c7b98e9f5250d181a42e7a051d"
    sha256 cellar: :any_skip_relocation, monterey:       "8389c108547ac2413bf98f5b276b329afb086c6d8e3203a78cba9c5ec0df2a11"
    sha256 cellar: :any_skip_relocation, big_sur:        "33cd5f5669c4937a5ad6167cb105a8ad685ef4c8699bbecf08bfc85d1968036b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cf3c53474ed14243c6571a0886ea56f603e52ab56d2e93415eef902afec5c01"
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