class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.47.tar.gz"
  sha256 "6f8e9a60b3cf63dd8253d579c1ca62eac3836d64e45f8a8c759250dcba755657"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbc68f3bf1dfd77038cb38023e04eaada766cceaa9b87720ebcba8cc952bfa87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "892b281ca8f543fc20603dcb619d5d9f9673e51f65fd857311761d5c65a062b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa81e1e5b6ba99f69d33117d6d6b49e47dec00a69c80117b0afca3e659bc9965"
    sha256 cellar: :any_skip_relocation, ventura:        "b1e4200121b232a002ce8c85b49f73b12e2888b72765470b69114b34d82e89de"
    sha256 cellar: :any_skip_relocation, monterey:       "e423e569f88d7283a55927578b6432cb41674da2cd1baba37eb83949b78d039e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e0065a3c70b7aa832a478db4c816df87602d65c839f5e5ba1b45c154e381d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9c0ab487d2b82204108ad4c926aa6b5e22866564d15d3c97c3bb24564a9d873"
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