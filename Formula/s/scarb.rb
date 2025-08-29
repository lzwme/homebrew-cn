class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://ghfast.top/https://github.com/software-mansion/scarb/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "ead56fe6856319a4a3d335bd35a3bb0a0876da75084035d8726b3037d7934743"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8853abc029ba73a1cbe3f873fc681a3e9327afab00dc505837bb14a5ba9cba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "816532d4d1e7bc5a64015ba46a682f18398c01b79a64ff58a84ab011647a49f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b7be0019de432bf92b8a2c6e7f2d6d6c6567fb8270368ad7e0e39ab6ae61d2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9005ac0220adb69cbb77653c8b5c525f0419b1e217cdfc5733e999692ce85b3a"
    sha256 cellar: :any_skip_relocation, ventura:       "0b3b716e2c70b04a9dd76d8feb2c65c830cf28b9f24f159eb251ec85750f7ad8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "379c16d4d18833d94b9b033de27a59d96af96842221ca540baeefc068fbef68b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9cdaa4f05e57b39503a4d38b8b1235f428e8171f4fdd1d6cfc5307cb884401f"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "cairo-test"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath/"src/lib.cairo"
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end