class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.152.tar.gz"
  sha256 "a3439e9c33e1e5b12b6a3c7e05313ddee2a0768ccc4babcd0e49356c86639124"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f3b5bce928e926a18170476df74e95846f03716816c60fe9cdcf61d367ae213"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "567f4c3a935a4ffe33906a5efc445a95238e2e32295b1b0f46e2fd98b35ec47f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c804f457050bb5b8fdff270cb92b76ccef7825f655f7ba1361151b903c47a5a6"
    sha256 cellar: :any_skip_relocation, ventura:        "5d91ab8e748392f887fa4984801ef014c849ea240afe073b10803f1e29bf2388"
    sha256 cellar: :any_skip_relocation, monterey:       "9c5914d3789cef52f56d715756fd353ec2b9068e4ea23030e178ba4b768c2f2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc59a50fe2b14f8fb54eb797a56cbf811ab0686bc1c741096c5825cc5f559cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17ccca8ed79f1ed20199496250fae7691736231cf86dd78c450dcc4fc70cbd20"
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