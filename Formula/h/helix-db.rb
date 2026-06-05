class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v3.0.4.tar.gz"
  sha256 "c3034653b87ed1f1d7cabaa06be6541127269218c43c9112cfea4f41c8574bb5"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "49815086eaf9f7bcd131ed9233412afa7b99f4ed63fd0f7f15a93f0edf749222"
    sha256 arm64_sequoia: "ec67d38ce7ff615397564158ca4bce8a9d062c05dc76219fe671772bfee14690"
    sha256 arm64_sonoma:  "3529f89881f410d929d2476b7a7c0859023d6aced1037afbf8ea0cdf30fe216e"
    sha256 sonoma:        "a176f8ca3a10d4c4b0b8de0609578cc0f2f5abeb02c8caca1f4bf00a05c92102"
    sha256 arm64_linux:   "aa60ce15e1f9a186841668125d2be1b2756d66127fb013f6b09a1d47d7ee499d"
    sha256 x86_64_linux:  "b5aa237c979c9d91373cc44d17143156a3143186014fc3a35071d663e0304b88"
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