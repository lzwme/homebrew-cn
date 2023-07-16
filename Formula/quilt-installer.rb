class QuiltInstaller < Formula
  desc "Installer for Quilt for the vanilla launcher"
  homepage "https://quiltmc.org/"
  url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/0.7.0/quilt-installer-0.7.0.jar"
  sha256 "ccade8c23b615229cbb685f9c7590430c66da64b80e8393f12f6b2ec24df5ecb"
  license "Apache-2.0"

  livecheck do
    url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8157ed3e9925e2cff652bc4773e6cd5dbfb3745b1dd2291e1ebd6b0a653c0c21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8157ed3e9925e2cff652bc4773e6cd5dbfb3745b1dd2291e1ebd6b0a653c0c21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8157ed3e9925e2cff652bc4773e6cd5dbfb3745b1dd2291e1ebd6b0a653c0c21"
    sha256 cellar: :any_skip_relocation, ventura:        "8157ed3e9925e2cff652bc4773e6cd5dbfb3745b1dd2291e1ebd6b0a653c0c21"
    sha256 cellar: :any_skip_relocation, monterey:       "8157ed3e9925e2cff652bc4773e6cd5dbfb3745b1dd2291e1ebd6b0a653c0c21"
    sha256 cellar: :any_skip_relocation, big_sur:        "8157ed3e9925e2cff652bc4773e6cd5dbfb3745b1dd2291e1ebd6b0a653c0c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "832e506efc2ebaabf6cc8cc90b000d6f0c7477fc858f6bb79ba1cdd8d57c39b0"
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