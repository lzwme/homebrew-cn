class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.154.tar.gz"
  sha256 "a3a8d8d90761efe4c7c1fa90cd9dc36d9f88965115985e68e24b8199ebe304ea"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a1b827092205cecdefbf2fe560e666b4ad23baff1f5c5281f4871fd9cc0b6f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a14bfc41bccc1f045b0960d87d0f7bb439b8dc7afe31e0a45a6a1fd07fb34e33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7525aa03f15697a50d289f145d6eab88a7e9607bafdc1c9ea8899047eaa6175a"
    sha256 cellar: :any_skip_relocation, ventura:        "c066a2cf5781989d1fcf6ca30d70594c41cc76ccac554858a8d961145c8d582e"
    sha256 cellar: :any_skip_relocation, monterey:       "595f734283156f1078c9dffbfdcab55bb7b80c2c785e7f7cec2e139dd2c4bd2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ccb429a0fc5a3210a6acb1d58279cc7361097a4b350663017c15c98cd3f18b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b4f0b530c854d8b9eb563d4193819205606b81b3a6aec7a23baa09e4c9db977"
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