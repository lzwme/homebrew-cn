class Rojo < Formula
  desc "Professional grade Roblox development tools"
  homepage "https://rojo.space/"
  # pull from git tag to get submodules
  url "https://github.com/rojo-rbx/rojo.git",
      tag:      "v7.6.0",
      revision: "441c469966ded2c7b4a5f7b9aa18a4c8a27499b3"
  license "MPL-2.0"
  head "https://github.com/rojo-rbx/rojo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "528d16663ddaa354fcf3d0c71f220196a2e5b5b0bb3c0f600dc30792b7486716"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a83beda14e57c30a2449b9b89451b9397c3853e5bc85123c25a02ccd99005982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1831b8ddcf74822f78eb2c755904299e80c7d815d8dfc585ae2f93688733794"
    sha256 cellar: :any_skip_relocation, sonoma:        "338553ac49050cb9a4478f14f8f47a26cae3c8b7f180e68e46f6c09cc15e7003"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aee4003490b49e7676b9142db3c9a52b29f77860c09e0f98f47a21167d8c3346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "366d55c2b92a3dbbabb07dccca2fd051ea4c43e7be16e8b63dcd293d2c610993"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"rojo", "init"
    assert_path_exists testpath/"default.project.json"

    assert_match version.to_s, shell_output("#{bin}/rojo --version")
  end
end