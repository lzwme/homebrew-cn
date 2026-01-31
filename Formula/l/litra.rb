class Litra < Formula
  desc "Control Logitech Litra lights from the command-line"
  homepage "https://github.com/timrogers/litra-rs"
  url "https://ghfast.top/https://github.com/timrogers/litra-rs/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "c17bcd2afefdc9634b22319a88ea3f366b724c046d84ca744296365574c69123"
  license "MIT"
  head "https://github.com/timrogers/litra-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d20facfab389e4384e0ad9ddc25209994a9d1f99a62f4e06b7de0e4c1939176b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c78ec1209989a8a4ab913671f63d9d438925eeb5c8eaac996ea551022f1e0bcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2127667a8e46a92e5e37d0a7790dd08db2e403ca0b8015632b10bc197d53bb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "de95f352fecb9f5975e631f4b85da72f352097177aba856f6c28f849cebcee7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1c3eacd2b01b1af5584e701288634a7bb2207f842452369b6cc1562ae979e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "525e76895c39c11297fec9578989775cc589c40d14d38dfdf93d6c19a701d987"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "hidapi"
  end

  def install
    # Update to use system hidapi for linux build, upstream pr, https://github.com/timrogers/litra-rs/pull/210
    if OS.linux?
      inreplace "Cargo.toml",
                /^(\s*hidapi\s*=\s*)"([^"]+)"\s*$/,
                '\1{ version = "\2", default-features = false, features = ["linux-shared-hidraw"] }'
    end

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/litra --version")
    assert_match "No Logitech Litra devices found", shell_output("#{bin}/litra devices")
  end
end