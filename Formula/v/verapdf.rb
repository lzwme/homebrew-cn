class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.117.tar.gz"
  sha256 "5b543bb0de00523b324d509c74167772b351b3cc994769f0dd21dc5cfd25465d"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "001e1b30a2b64115b2a313d17038517de4b02aca7456382a4486e4cfa2a3ff6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba851dbde1c203c1bb2b89ef08667c4ad398a7fd0332d16f60163b08918f8c9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5660fcf7ec5f68ac5b2fd1e04343d8917b283447b33c8157cd1d264d6513a64b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4059f312cd225977958a322a7e4dd82bd52e657acc74db1c469dfa79cdce43a3"
    sha256 cellar: :any_skip_relocation, ventura:        "54e13d6bd56c1063df5f1c2ccb92a7aebbff7e861712c6a938ef158cccd830ec"
    sha256 cellar: :any_skip_relocation, monterey:       "9ef9e7cbad662d4e319103e21777978de83ab3c0d6260960b272bc7fbbe91646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "635514d5592eb26aa94693445fb011d5f00211dc71cb8a8ac3f9ee306da26a91"
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