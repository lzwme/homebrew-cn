class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://ghfast.top/https://github.com/hirosystems/clarinet/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "f6bf3b096daba177c3b23e19dce93c42d74789d82c5397f7d004ee08c4633fa7"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d1b6c5778f2006a0b10f74755f482867fc55f14bc93282e91339355ae28c2a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbf38277613ce897db76f3f1f59ef6aa8333fd74a744791f4725388504d7c7d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a85f1b83763fbf8a4717b6822700dd4d41c3da3209c21bdf4877f01682867887"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a2b3c8dc3bb63cd26e72a4d301c72d83dbdccae3b2516213f5177ef00d6b5d2"
    sha256 cellar: :any_skip_relocation, ventura:       "f0fe785013c23b01dec9afd465d542df85682ea6a16f9d9fc41c2bdf6b3354ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "537acc18e748e14852cec4644af9bd2200ac23eac48216cea4055cc358bdbaaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c6e10be769908b813ca424c81c77a64997988fe3099134a9afd999af440f62e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end