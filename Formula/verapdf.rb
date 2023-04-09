class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.159.tar.gz"
  sha256 "7890018314d89903689567881b83d8039736e3885efedb310df4e4d98423a45a"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc643ff912034a050088aec73bcb09074f25772cd720edbf1836a56ffb0c35f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1b09cc703933f43d55287622cc2b3c377e464a41b449e701be0f862d267cbd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc28d35b1295baec3fdce463f763deb03e14b7aac245ebef47e5ead06f1cc102"
    sha256 cellar: :any_skip_relocation, ventura:        "698324e8b3510a88eee414abaa43711fa7d5b5ce0b01160fb91e607a8d4ed5cd"
    sha256 cellar: :any_skip_relocation, monterey:       "1354a68df40c55ffd046658ba037d79331dc9f00fa1052d8123f59eac90da975"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4a65c164389d1b00b16fbc287c96b6248820155fa9f6bf413fa4e1eb52d6d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "697d3499193954b86a758b2c6154f99ce5a870211ba60936bc98fc2114e919cb"
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