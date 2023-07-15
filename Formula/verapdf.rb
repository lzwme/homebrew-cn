class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.20.tar.gz"
  sha256 "5a6245b5f911b8e5f9b3e93cf298f7c126348e06c7205d68256958651d8c7052"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deea4a52e9dfbccc69d1186380c55b40c9a798cf953f09e8dff962e56aacff70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c976f1851a796d3d1051a5496be377897f6086f9402647a9206452a05a561d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddd8ad0edb3e431be246abe518b753d02eef7c293f0daecc36f952b2d5adcd7b"
    sha256 cellar: :any_skip_relocation, ventura:        "1055411933b33c27a247cd57901c25b156e5a7d87cf97686e9023b4458852862"
    sha256 cellar: :any_skip_relocation, monterey:       "9b90aa4ef4c7f242105e8613e4fc138de07a97570370934f5ed844cb1afd46f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c87041ea0e7f8925f7ca487ddf518ee7933b1918452b296c867e1ebb493a2d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b13e4386bbb045c3fbe5a33e2b6ce869c4580b752915488202ffa83b78428ec"
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