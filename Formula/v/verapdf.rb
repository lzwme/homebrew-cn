class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.124.tar.gz"
  sha256 "c0a080a653377b1dae8ed34a8f4b0b48c2bc06afe4b0c6a78dc9ab813f4d77ee"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1095ee573cf99e6f0c3b158bd007595af29e4410d2cbecbb8266a94973f12b97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8fd11a01f17560d108daea70e3467f2262a62dd104b306383c072458cb23931"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d58d7f72089557be62f6200a1cf5301d0a8bb43ee1eefce4f8d0096727107ae3"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd35e2cc3efecac4b6b8ad2b84732c1be36910fc8a65b9e664eb57977f1c9c05"
    sha256 cellar: :any_skip_relocation, ventura:        "7ea217cd418feed85b6d80e2d74206a37df62b7b68fee72ac7db5e8b0d3f7925"
    sha256 cellar: :any_skip_relocation, monterey:       "4ff61b9c25442551277ba3ffdbe181704a3aa96212b52f12c62c651fa6d59958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86723f78bd38a9e2a2a1bad0dfa7c4690642929b1d074dd9f8fb401860bd79f1"
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