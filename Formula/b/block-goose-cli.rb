class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https:block.github.iogoose"
  url "https:github.comblockgoosearchiverefstagsv1.0.16.tar.gz"
  sha256 "dff8d35e9d9af2c5dfe40bb56e2bd0a7d35f69cee332c2870eb0449d0dd7c380"
  license "Apache-2.0"
  head "https:github.comblockgoose.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dfdc5bbbe7e6491cbf13de1b66e57c7546bc3bb000209ca82cf7eb43ee7bf81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "119d9da9eaead3983713996bf945e0f89f42b7106f5e9f58bd894541e54ae9bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fe13632b0925a7ea89f280ec59eff2367c2426a5c3ccb13bf2eaf05d02e0b29"
    sha256 cellar: :any_skip_relocation, sonoma:        "97fe4cea179b8b78380f02f3edb74bff251ff6a00d1e5d369efa64e4eeb75839"
    sha256 cellar: :any_skip_relocation, ventura:       "38de2991ab59e973796121e44893d06dd0c26d95341ef4155f885875a986ade1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb88a85d070e2dd550d19b13ef89f60cb0795b7c4c2e798f2e303898a0465836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eec26f4285a6b0bbb3c4a33208a2bb994bf1ac74afd1e55c91117572fbc71ff"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesgoose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goose --version")

    output = shell_output("#{bin}goose agents")
    assert_match "Available agent versions:", output
    assert_match "default", output
  end
end