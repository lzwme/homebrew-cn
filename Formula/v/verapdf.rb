class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.151.tar.gz"
  sha256 "f9bad932901d10336a7dfb272929c2499bf1557b1b8fa8de8abc00d181ca287c"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e28fad2d49a19fdd4b5c172caf3285f11e32ef97f99eab61c5e9b5b3de853fb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb28bb4bd22140a559707805e52eedf85f929fb1e335a5bb91cb7cc7f16f06bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db91136375c6b0efa56f845eb83330655c38f2e88d87f12cba966d1c8e1d493d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d52d257a0443772e700384c63559b582ac3d2d800d6a5c51850572afe180725"
    sha256 cellar: :any_skip_relocation, ventura:        "2e0868acc2869f0a8d71e9c836b122ab1a17f1219e8bc1b79c87590504563c1c"
    sha256 cellar: :any_skip_relocation, monterey:       "f8f177a5a061f892e3f5d7e833ecaed0a8542f5336cbc4bf4bc478abcd5a83b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2769013b91d51502bd4e3a5f315785138b9aada5367bb5e015ed2558bc5659fe"
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