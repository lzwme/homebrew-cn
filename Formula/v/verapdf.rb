class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.98.tar.gz"
  sha256 "42016b6764c6aa80d924e54bb7539c437a08205f340195b43927197de493bfd7"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3f561c8adfbc78793d9ee57c5822f4048ee4d1e7eb4a45b68532797f0d86c3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c340ae06f4d5ee4d3fac36a83c0e6d8da1ffe2e6ff154992224e6679f21373a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64e61afc47e032cac17d799a9acb4863f076c8381b7ee3468d2147b20c165c59"
    sha256 cellar: :any_skip_relocation, sonoma:         "459c667237717552c233a1a4fd6dcb7da4364707a9528c999e1f2ccdfacae5e8"
    sha256 cellar: :any_skip_relocation, ventura:        "e9d34d6c97d0bf4eb0f6f5afc9bde75e381727010bbe587dd86e0f03b420e56a"
    sha256 cellar: :any_skip_relocation, monterey:       "4ac16a1a1a1ec0af599c1c09d23a4c73bd51ae1c965cd3f64f39019b74537696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "087902114052e208e137945e8b82568dd7847fd7c60915e479fcd959e86811cd"
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