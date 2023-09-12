class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://ghproxy.com/https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.2.15.tar.gz"
  sha256 "abb6892640d4dbea275cf2842270bd5589101b1d90cd013c11a7f8c97a5497c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e1150742c7838e49bc7d1dabcfa57fb08b74f8410bb0c4243a66390e961e97a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1093be1486d0f65a437a9dd0145b9f71469ea89298ed23ddc12af737eeaa210d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c74c9a5cb6e5b1ba7893d96106f6e7c3bb610d80a327c6c0bf37f3a540f47e7a"
    sha256 cellar: :any_skip_relocation, ventura:        "e2b7466b089b5c9efdd9c229418fa5d5e2fe44a7fd8b1ddcce16bf668f8470d3"
    sha256 cellar: :any_skip_relocation, monterey:       "693dc19ca84a4417b93b85ed7c233a78570c6e29dece00b7a6ad80cc3b4b6749"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9f857724c2df36e078b175af793a00e2c939f1be19cdba8a06478a735b7abcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44ca0ca6a0f77fa0b82daf1de6e622c273efb3fdff75df3702da5f396c374b56"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end