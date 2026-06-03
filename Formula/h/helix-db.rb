class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "a9bcfcd879449f5aa523865d794d74ed6b82bf50d588ef3670c71380758eb6c2"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "d4a2438d88fbd3adcec505d02afffb9300cfe97b52732f788fbbab96dc72a3ee"
    sha256 arm64_sequoia: "296f6e07ddd66750d4c2db3607ed9d1517815d33fccf1795ab4a16ca21178de7"
    sha256 arm64_sonoma:  "dedeb9885f6649443173a049530a83736d4460f6da83009743e21e635d930b5a"
    sha256 sonoma:        "41c0f53cff257ad741cb6abb8eed610786564424740ef7131fe36a68a5a3fd39"
    sha256 arm64_linux:   "0917c4137b3abd9393c5340d322f9865d2658d081c9c7274b4fa766698b27126"
    sha256 x86_64_linux:  "b27126eb0d96bab51a612068803967bb40ada008dbae95ee5dfc26b89f918f30"
  end

  depends_on "rust"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "helix-cli")
  end

  test do
    project = testpath.to_s.split("/").last
    assert_match "Initialized '#{project}' successfully", shell_output("#{bin}/helix init")

    assert_path_exists testpath/"helix.toml"

    assert_match "Added 'test' successfully", shell_output("#{bin}/helix add local --name test 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local --name test 2>&1", 1)

    assert_match "helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end