class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.109.tar.gz"
  sha256 "cb0fe54d4c0ed9bffb1337a961220c53c81021a56301870a0b2002cd5381ef01"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84028b164c367a7b63e15b6fb162c7b7b4c2e2b26c68322aad4dc5f1c270fc53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d823f44ef420b57abab7567434de7177c11c88937cc253982de51f3159d55bb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0b11e4592f84a349b0ecdbe4a08a8748cbfa52b6a0345ef9d5fcafa6d589c91"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f647751c457bd8c952b32f77231d8e5d1eefd05f6efd9f10ee277633b3cd5ae"
    sha256 cellar: :any_skip_relocation, ventura:        "645fe25f7d7a0af9031d043baa04b8827add1a02758b7f6f7643ac219ac49fe2"
    sha256 cellar: :any_skip_relocation, monterey:       "7e72104130e96af3f8c49443c345c90c752d007f043a786ea3b6b6a3175d15e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b2f9c106247cb73ef9ff39d4bf530acdba080d14a7b8cefe3ca8648db16f938"
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