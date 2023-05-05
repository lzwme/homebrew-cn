class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.209.tar.gz"
  sha256 "c6fe432bf2dff9b5751eb6d7dd4270abcb95b0b92d7899e8994ea57563b42948"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8e294270f40bbdc316be24094723e9389d63a158ba7ecb93be35190ade25e04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b90daded32f17aca70009b1c7441345ee693bcef1ce3f1019abf7fbd994169a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf4388961205f5a7f6eca508bd84b23b83c1f66e9536abafb1fa8bf68d239a46"
    sha256 cellar: :any_skip_relocation, ventura:        "f84008f85be681145ec7d029daccabc0ff0fb1031f8b50608db55be115b39bcc"
    sha256 cellar: :any_skip_relocation, monterey:       "7a8bf35de78f83f96bc071d8493981cdb470a6a82543be87cf9bb7a805af7d06"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2de27f5f91e51586836958a561d6cf1dfbe77fcf79935dc2c6f114e62901a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e222ff495ddc63ce1aaf4facf738db3b8e3f7dbaaa76266b7e7d51d3ee365d24"
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