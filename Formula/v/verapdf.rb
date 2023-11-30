class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.116.tar.gz"
  sha256 "253de80112cd990317a2e85ab15c038a2d6b7e49d87e310638548efde80a81be"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49f1e7e6453e766f9ef955daff0651b4875f7acce28aecc4be33710315b31ff8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08a146472ca1c10be30a6871783dfe3abe5251eb1ac96f86910d69d42c9b931b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f298e429d51844c700f0f8bbb72cd2565cc98369d169d76c73e623b807fa5f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ced673fe039694f49703212afc38320df72ed78905cb2e02660b8f7e9b727d6b"
    sha256 cellar: :any_skip_relocation, ventura:        "3a0cfd10795ad4a8f41b7af601a6f7c8c3a6c4e076858c43a0279f151b66805a"
    sha256 cellar: :any_skip_relocation, monterey:       "437924060a3ec1fa66d522f5b32caba107ae314344788bf87067985d78a95926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79b3972ef2019f2ed40a2d16f8ad3f766d9c150d9ab3a6ffbe14c82fcfe9b264"
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