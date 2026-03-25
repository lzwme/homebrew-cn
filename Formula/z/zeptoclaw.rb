class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://ghfast.top/https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "748b9ce203bdd6589c169ccd99dfbbe0d7fcbe8efb29eb0b5073087e9aec0a3d"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8aa173acda40177cb0a014c5e5c591d65f90b67df0b430032bdf303ce65a1c85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3759c32907dfb8734f68e0f7383c6bbdbb5a7a7867b41cd4981ef7e09201f35e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17dabd4796b1274417da071da686da3f2c6e187e662c913d0a60d0db11ef2695"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cf36f3335a9126b68a49599ff8dfc8e31d2e0ad4b4d9da66bd85503d1b0a62d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16838112c181ea226d94e833958bde040932a135e869e9ac47100d9489803478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e01c3f2852b2576e3ff3b3ae8a4a30935669ac23e8dd5a4a7346d1e38eb4aba"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end