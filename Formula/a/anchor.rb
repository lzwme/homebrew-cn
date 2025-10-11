class Anchor < Formula
  desc "Solana Program Framework"
  homepage "https://anchor-lang.com"
  url "https://ghfast.top/https://github.com/solana-foundation/anchor/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "e45fec416a1a13dd20112f3f52855b91180448b3298808d7e42c6cd57ad4ae48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "efa83be67b8c4ef3119a6b2cd93ac097834419567ceb8fe9b24513cfe1a84a96"
    sha256 cellar: :any,                 arm64_sequoia: "ee130c6aca80d10276703c3c66902d91d4bc5794e34b60f8c4a4dcf7b37d9ea7"
    sha256 cellar: :any,                 arm64_sonoma:  "1617688b9e102a9ddffee0ce691f22d2ddc7b233569ee1c3d8bb11008e3d0045"
    sha256 cellar: :any,                 sonoma:        "1dfc139234b277777e469c8b0dc3dc503b1897ffa41c19d03f1ef58e5b43e07b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e3973d262aa79319f11d4986b61cc0da7ea61068bf1a148cc6574de45609290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f595b09c4947d0f474539715dc33586b9c4f6c4b57598756cd3a9a9fc36f674"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "node" => :test
  depends_on "yarn" => :test
  depends_on "openssl@3"

  on_linux do
    depends_on "systemd" # for `libudev`
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "anchor-cli #{version}", shell_output("#{bin}/anchor --version")
    system bin/"anchor", "init", "test_project"
    assert_path_exists testpath/"test_project/Cargo.toml"
    assert_path_exists testpath/"test_project/Anchor.toml"
  end
end