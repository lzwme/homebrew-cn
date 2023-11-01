class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.93.tar.gz"
  sha256 "ab53cd1e45e2b07a0b462c8e4823da13c53a1c40eb27362f5bd855431651c8b8"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac940b2e4f053cb1dbb6e373ea0d3485d997338e9bc9201d83bf5b1f4e863baa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17fe5180000fdcb373fa3d24bf6429aa3ece0b6ca7513fc3393a359aade3abb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f17c0dd6bcd0a1493298609ea006ee3f8930b8af889dc9cbce7b8e28d070727"
    sha256 cellar: :any_skip_relocation, sonoma:         "12963e4dcc538ad2a1727678f4269851f4167f5186dfbf4de744b41aaa36c056"
    sha256 cellar: :any_skip_relocation, ventura:        "f2716c7f340e8e76e48aa2de49bcef31e3459bc70ce6a7131a213c48dc4fc229"
    sha256 cellar: :any_skip_relocation, monterey:       "335bfd42096f2249297cf6e65fa72478c1388a475aef1d9fb34a01ea51c4db8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f3aed3b7d67bf8fb8c2d37f6f5b3b3271bc2e0f12a541e70326c0c7711596b"
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