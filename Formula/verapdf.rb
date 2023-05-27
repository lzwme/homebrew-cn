class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.227.tar.gz"
  sha256 "9120424e6bd187ec1527589540840b43913f1f0416f0dc75820556e11787d3cc"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02f082a62dfc90346a1fa31aeb184bc8bfcbe4fcd3b097846bfe18ba496dcaf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16a6bff36b94703da65a870fe698ae83c6e7c4e5bdfeb348ad65c5ec31895660"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c83387bfb0d4bf8b3e123516435b4f84e8a66fcd5b1cfacedb80cebedc3ebce8"
    sha256 cellar: :any_skip_relocation, ventura:        "5d3d94d039d07ba1b69258a6765076f8ffe485da7e39cb4960cfbb4b71eecb31"
    sha256 cellar: :any_skip_relocation, monterey:       "d265cb7a11bffadd19d77340d2e180163b288c942e658ff76c96b0bfff0d3739"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1085bb3a3bdd8334452171d592dd4b3bcd9e02077bf9e0e703203f2e4965d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31ff3fdbc7fb11845e65972a0db345cb05bf3ea9d43571cbadd64dd72d7d5d96"
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