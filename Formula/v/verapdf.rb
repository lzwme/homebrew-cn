class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.76.tar.gz"
  sha256 "132ca218196090ccbd3afff85b7da4650142f42fea71b1c1abc480a65ceb4839"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d50a9693da536c087b69c69c51c6953bd2d3dbb77e04af4f3504cb7afe39834"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e95f53c9bffe038a1d50d8d2e0794c9786764cc895a155e879ce7021969edfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8fd52290af0c106cf40c055a22f534f7f89f9a4aec9126b9f44f4da1a85fda7"
    sha256 cellar: :any_skip_relocation, sonoma:         "0758c702dd77cab75d82b812ec18740904a05c6aeefe8d546e62f6f40c5618c7"
    sha256 cellar: :any_skip_relocation, ventura:        "20eb16d6d144c38ee38940ce3405b73b957c3e47ffb78d7935582f25d8b20a01"
    sha256 cellar: :any_skip_relocation, monterey:       "947e4e3e210e2b61dd59aec82da3665210e4593c7f37f814830d03c7fced8044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64c163f64ba1f6a0bb30104824ba832fcc11342673aed48e239bc38e32c51df4"
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