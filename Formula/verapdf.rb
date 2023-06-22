class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.239.tar.gz"
  sha256 "534099411476588f2b90585ef822af8473cf0a98a9f4be502414268a79cdedd8"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf88d89b4c341082a39282d7ffe64f60593592d8eee2545bccdd98ecd6f2a347"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "003cca6ce6be36bd00d7a683917c8c115ade8a8939440af973cbbeff5e5564eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44d36883d96f82a822553bb723d28c1fbbb50bcf843a0a57d1d339968286402c"
    sha256 cellar: :any_skip_relocation, ventura:        "78cc102960a2b1bb15eae10c6837d426ce2f7fb13924534248091b36e4d7cf8f"
    sha256 cellar: :any_skip_relocation, monterey:       "ff725cb9ca5d8b005a152a03567d031c15e93cc950d3155acd42abd73c6272b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f2df7442b183eb127ddae1d9b5bedc8f735e7dde100f686f5e47e5a7b93378b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fe6c49497f9fee4dd95de5af94c1ce50ae5cfc8aa39e9e21723b59c0243d708"
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