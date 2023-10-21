class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.79.tar.gz"
  sha256 "6f700b20d801aebb8d130ba5b8e6544bee2389524875fa40ff8d1f3063df02e5"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90238f61a1c27c0cb7ececba77708dce8e6629b0adab7ae9a74b7e9f2fc9ee08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aaa7a8abb69d5d5b34befe756c03095f8d93f43cbf19be0702b514d539b65fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28f71c68d064ea53a1a4599fc355da07be2e8b71a642a00cf59393aa83dd0280"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ab324fe0f4588355e338b74d550f4ac907478d5b9f9c462f1dc5ebfd676dc78"
    sha256 cellar: :any_skip_relocation, ventura:        "bf992444a9af67595d89bb8c22106a0e4b073587b7ef4e8b4a257f58522a1906"
    sha256 cellar: :any_skip_relocation, monterey:       "930b6483180fcd8be04414e577f403c7a0e84e0b50e97c4a2caad0c88d8c8387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80fed01f3ccad600dd193ff132e1ab4904ddf15f1d2b96d28878a2a723a20fe4"
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