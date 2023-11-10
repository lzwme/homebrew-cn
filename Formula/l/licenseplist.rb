class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://ghproxy.com/https://github.com/mono0926/LicensePlist/archive/refs/tags/3.25.0.tar.gz"
  sha256 "49a7b65fea46b71a70690555ca0c9c6179539f35797779feefccdc53ef73254f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96c56fecbde595fc08e1814f85cdad34da7000f079424daaad82d5e658802e8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aee5145ad5f851377a4e4d0b63ad8bfe9a70cac72d5b573a8aceb4b893f04ec5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79feca226cf04328a539c939b4614baf8505e1e9800fa581d59e7e322a735701"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5bb8699daa94bf9373e88b276cd4309974d20dfa5c94494d1b86336b8e0bdb1"
    sha256 cellar: :any_skip_relocation, ventura:        "3b46e6fc6b2331d6cc28a3a621be4fcdda75ab326354201bf1545a15f84aa6d6"
    sha256 cellar: :any_skip_relocation, monterey:       "569bacc0080bf5e1b4bf42c5586fa457960a2b68d744db99721df69c679ff2e3"
  end

  depends_on xcode: ["13.3", :build]
  depends_on :macos
  uses_from_macos "swift" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile.resolved").write <<~EOS
      github "realm/realm-swift" "v10.20.2"
    EOS
    assert_match "None", shell_output("#{bin}/license-plist --suppress-opening-directory")
  end
end