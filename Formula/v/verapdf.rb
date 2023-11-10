class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.103.tar.gz"
  sha256 "c7bc8c477729be081d5eac92825314a96ca0030299aaffb01ad46fe263ac3d1f"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff0c14629601d575f3626b6594ceeea10264e57045ff7364dcdb8a5797c11319"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96106afdda258c542de6a63ad6ad9bb8928d4d6c39ea1453dd7373f96d953bc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "604ebd4e1009e75c73b590311799098677fb838997c4d6bcd2eac8ba2ec49b19"
    sha256 cellar: :any_skip_relocation, sonoma:         "297d3528b6aecc5920bc340c69b39059288f728c6c15c5cb49e038de8b0f31a2"
    sha256 cellar: :any_skip_relocation, ventura:        "f29ba27c7fc1d025b54560a4bf0bbbb7f3ab3da91967566ca525be37339cc254"
    sha256 cellar: :any_skip_relocation, monterey:       "451b0813db0657d0d5e155d118d2eaa23a212e00e14d7ee2cf38e841577c23a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7738e04f9a36536f2a3b61195a882340d19f5c3d7c79eb0b3742987799e03209"
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