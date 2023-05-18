class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.212.tar.gz"
  sha256 "43a7d7bee74d137d6c3705343543c9c75a69baeebfc229225111caaad0dd9ee1"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d66259b93d5dc8dc4c7bec40ffcad3df3ea6014637937b0a20282243cd55ff1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "876dfbf786f269b380d9638e2042bf9a431c233ee6bfa1276d6b14ba6aca0b65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a70b2792b720305732878ad75c805ea8f16e03d39801b75ac9d55d50cfc995f3"
    sha256 cellar: :any_skip_relocation, ventura:        "d5415036937978a776194284eb7180f8e6b19c2f2a5e27c87ec2d624d6048734"
    sha256 cellar: :any_skip_relocation, monterey:       "633c21fdbdcfca07cde434f6ab6960e5cbc139871f87906f77980ebb31e94278"
    sha256 cellar: :any_skip_relocation, big_sur:        "d783e68ff5fa21be6568cc411a3a08a3224822345fe1d934e5060e66a8f404b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c43159c9fb6d47354f0b09a7ad3644a0df3bae117b862e5f0e111e4e43bed7c"
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