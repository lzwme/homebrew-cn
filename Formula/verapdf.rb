class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.13.tar.gz"
  sha256 "228254654477792d4b4d32d2a24eb26e45d91c0544b438b12c715b3fdcc0b997"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64d389c5733331e83a51b213537d239f2f47e06dbb121488cc04963a6e7e9147"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf0b6d97e7bedcce4dfdf519741ece97780a49db9a060c6d807c9e26f3bfe39b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a0589bf84979f9c0a022a6ce91484ca4252089a2d82b310dd661c4e8d0780be"
    sha256 cellar: :any_skip_relocation, ventura:        "c5afc9f1a1e2555c7f822bd604909866999b5be62f3399a4bd4138e4128c74dc"
    sha256 cellar: :any_skip_relocation, monterey:       "b1b65e058cef78329e7b19e9dc468b3bbda9eedb83aeb1734679bcc4fc457792"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ee258aad91284fa3bcbb60c93703b123fa530f1002e1e58b508375172e556f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a085640694bf454d797d28708e94d563ef4564ae64ddc634804d4910c9d4108"
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