class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.31.tar.gz"
  sha256 "45e6f2d8e6fa8a2f0c1ebab9883aacf71eb985757125b46843b3215c3626736d"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9aca336159744634d2d54e30190691700da681c748d5f92018b446a610ad3d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbf6a4d4172f0f4d92c012400924f2f57fd088550f6d96a23a58fef96cbe4252"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89da6f65ff35e5f4df91f0186e4916c086f7e61d6e6a2e361dbf2d9e07c8f4d6"
    sha256 cellar: :any_skip_relocation, ventura:        "9bee45997f5b94f882299521ddb0c1518e9feef2ae4caa8ab64b5b55ac8eb35d"
    sha256 cellar: :any_skip_relocation, monterey:       "9bb2349f1e1b9d64839e7b481a23ed14304b449872072f3007ddd210db1a166e"
    sha256 cellar: :any_skip_relocation, big_sur:        "49590d25a837bb1f3b980aefaa6395f331b7e8c02d8d2e632e7e447381b266ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f9f577e1a7d60857d1c59fab4b533c1418f09e857bf086ee99ef67e8bd60946"
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