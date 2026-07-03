class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "d88cbbc05d59d559a087c4d6bf5b6a35a8515ccaebd9d0d573c00009d7e05a08"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "6d34b9820ec607b49664004692ee9e0b44a00694bb80cc3175b8925da67f2105"
    sha256 arm64_sequoia: "16aacc59f042c9ad678bf734e32653c0f14c6a2f964a5bbdd2015eebc1ae4adf"
    sha256 arm64_sonoma:  "a77fcda6faef75fa2d66a7cd0e20efea8a6f996eba25a0d26b0067ffdf2d740c"
    sha256 sonoma:        "70756fa0e0603acdd783dd6776fd3cba88c287ba3c6a6c47728f931a3dab4b27"
    sha256 arm64_linux:   "9d3ae2410296e2ab776d520cadbd2fa15234e2206801b130a1960e15cc7fd635"
    sha256 x86_64_linux:  "496073766083d8223f6fb73e30f1625341b6f109467d0904c89c4f28e7655a23"
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