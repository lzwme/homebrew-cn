class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://ghproxy.com/https://github.com/trunk-rs/trunk/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "b19d6fa45e1fab883badb9a2ba92277ac1bae6139e67d90459fbdf4247cd3a65"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc9aa955c775a994b67b19e9e01e76de56dcfe28ecf0fbf22ffeb089ba9c2d0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4e786193d5b880a3d1bd787514afb706a072938be78803aa7d16590916ec12f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c06d178c770e70c1de040e9421c27836695d47f88ef9ed2f0205df38ae86a0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "814905f8f47077614bd7815524281aaf25729b43195c7c48e0ab6e4ba2e9dd82"
    sha256 cellar: :any_skip_relocation, ventura:        "86a44c6b357c0cc2ce95fb0b7d6b6b58178d2dfde6ae2f397d5be60e1f93008c"
    sha256 cellar: :any_skip_relocation, monterey:       "f912ee8e6a113dd4c64f66736ff2b38074b61107436147bab719de25a37839d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "791682bc3d2d25931a6a6f89851b5f70589dbefbde5ace58ddd0b006ac6e25f8"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end