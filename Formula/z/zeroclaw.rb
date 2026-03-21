class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "86e9720d3ba9dfb77f75a70b269d4e972328d29c4f8aaee97cd1bc570e794e46"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f91a73405e6102249bc5d60b3e8956e89a9c9d2d8d6abc0602b50038aaa84a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1465783850bc677935bce4fac659e4c9dbe1ee30ddc1bb59faf3d6ad1f3c76a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1141a1096dffd11eacebe041416f63592c4b266895820df3df6a24e0bcff1eb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "652d87772cd2af340f0193a10d4118e7bf315fcbbab1f5d1af95acf08aa7a77c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd54a694c20b50faf1e874b42132cb8f66ad2fc898c5805fdb7bd374a272283c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b2a62ff9318432ae42e9f63dff9bcca08d8931a869f5e42cfa6ea2ce4df9659"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end