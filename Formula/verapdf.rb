class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.32.tar.gz"
  sha256 "9a9a7c4404e3273d0b75b237973b7bd0fb87ac7f3fe381ac8d5e0f95e3f398cf"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1173a3e47ccf67fc7c9783951b40136446993a8f90878528e0c70f054552c92e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bdb40659619eb2584eb2be5845f593f5434e4faa247f7e1ccbad5727a67608f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9c020375e7aaa1bb367e04a1a79e0751c3b5d5abc490447247634d3ccb39fd5"
    sha256 cellar: :any_skip_relocation, ventura:        "8e955f3e1143cf6b034874c9966319cc9f3674619947b550d6b1288cbce24031"
    sha256 cellar: :any_skip_relocation, monterey:       "e1dea97d1a463591d2d81fa1fb07c29f4101aea8274fc4ebe7371246967a0b2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "30479895fbed6148ad8ed60b5a033abb88610754aa2b879fedc7ac8d0386ecf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31c06621c7e9bec1f98cf2b9bb65d259ad2ccfb8b4fdfbe7e4081b1bdbbf958a"
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