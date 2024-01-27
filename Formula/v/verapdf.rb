class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.178.tar.gz"
  sha256 "1672b25a62b62f5ccad61094293b1fead8c53acbbee4a557894000f03693a806"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7047399e2b7639cda9d7cdf58bb9d8b12ccbabd2877f8947511d935db01e4f54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36949d466a6fa30e18849dc54dbf6bcaf14eb602c838821f5216776f9fa91e59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0143fc26dbcd5fecf12f1205f0830b724d9caa608af10cbd2673dcfa353f774e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4136c5309587df7b0174019a9a0ef13bbc3645b0ee490ba58d155eaa7deb1d3"
    sha256 cellar: :any_skip_relocation, ventura:        "ef0f54df610a7092cf072eaf0632fa7b94a28e5c84b89a9a3849d69d0a7c8b3e"
    sha256 cellar: :any_skip_relocation, monterey:       "f428dc3befa5b73ef6d7318d7671ce869654b4017b3dc5d3aceace630defedc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d1f40bd8e414ca02efd2394f65d04f8b1f67af188f7caaa9541283ddab80d5d"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "mvn", "clean", "install", "-DskipTests"

    installer_file = Pathname.glob("installertargetverapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec"verapdf", libexec"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}verapdf", NO_CD: "1") do
      system prefix"testsexit-status.sh"
    end
  end
end