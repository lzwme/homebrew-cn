class QuiltInstaller < Formula
  desc "Installer for Quilt for the vanilla launcher"
  homepage "https://quiltmc.org/"
  url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/0.8.0/quilt-installer-0.8.0.jar"
  sha256 "a4e5f3e6782a2175bd10161a2d274006bc59bc0c1699097f506a8794bb13a39c"
  license "Apache-2.0"

  livecheck do
    url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "071f7627bb6bd9644d1b8ac6204453cc3b0dfaae81be4b2877db841ead4077d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "071f7627bb6bd9644d1b8ac6204453cc3b0dfaae81be4b2877db841ead4077d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "071f7627bb6bd9644d1b8ac6204453cc3b0dfaae81be4b2877db841ead4077d7"
    sha256 cellar: :any_skip_relocation, ventura:        "071f7627bb6bd9644d1b8ac6204453cc3b0dfaae81be4b2877db841ead4077d7"
    sha256 cellar: :any_skip_relocation, monterey:       "071f7627bb6bd9644d1b8ac6204453cc3b0dfaae81be4b2877db841ead4077d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "071f7627bb6bd9644d1b8ac6204453cc3b0dfaae81be4b2877db841ead4077d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdd495cfdff0a5a402eeebaff89f3f79eddcbb318a2d7d0116fc762aae9ec31e"
  end

  depends_on "openjdk"

  def install
    libexec.install "quilt-installer-#{version}.jar"
    bin.write_jar_script libexec/"quilt-installer-#{version}.jar", "quilt-installer"
  end

  test do
    system "#{bin}/quilt-installer", "install", "server", "1.19.2"
    assert_predicate testpath/"server/quilt-server-launch.jar", :exist?
  end
end