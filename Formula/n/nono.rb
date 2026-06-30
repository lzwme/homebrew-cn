class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://ghfast.top/https://github.com/nolabs-ai/nono/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "ce0e794676003f405dc6a297fe3d90079d00c19ceec52fc5c3c282867080b769"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30194cc4b59d64f0399b79451caba21149fdaef9712967017a480dfc4c4cddd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5dac37a5b1c0ba52d24aef20604a6090532bd4307f31ef1139794aa22ee6810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe9a83e8aef2829e634efa8995029ef45ee5e88c14bfc6870d4749c8ce46a26b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d0ae47beccb34c95946c81db270d0135024e8babe2c3ea0d80ecd16c1c893cc"
    sha256 cellar: :any,                 arm64_linux:   "0e4721125e0df8bdb9c4b806f4e92273e42aa8eb366608792864d563fda935a9"
    sha256 cellar: :any,                 x86_64_linux:  "2d727dc1abe4852ef11d1c05f0226d5dc905e8d41e5b536a14779b05b55a7629"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end