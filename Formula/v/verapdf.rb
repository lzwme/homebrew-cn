class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.172.tar.gz"
  sha256 "0ffc00eac14a6b8665956e2dfa2c951393b37167e8611f74791fad07c10acbec"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  revision 1
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25897b88c57e5a3d343e6e81cefdddb0431208ca29c49f53f6a50dd87b0925a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcc73c86fe6f02ec1a3fcbfc8b72a1a087adb251ef1d68c61d932f0392df5209"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3b6e1b33e591ca2c915150f34576c0bd3fd2f523e7f136f956b14f457047ff1"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d5501ef463ddb4b01dfde39bc25ed23a09aa9b4f0eecbb1af3a86536f6d87b3"
    sha256 cellar: :any_skip_relocation, ventura:        "0659b8d5c75df54dbdbe6b2b6d37ea95a63ecdbcc72d380119903a8c53e64717"
    sha256 cellar: :any_skip_relocation, monterey:       "2b61f808c2d1ba20fe153bce2c764dc16e0bcd20c06f970192366212abfa0200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9a3784714fb3840c925b8f35013c780d4724d751386f7b6f49aeb731d985720"
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