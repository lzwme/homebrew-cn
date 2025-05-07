class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https:block.github.iogoose"
  url "https:github.comblockgoosearchiverefstagsv1.0.22.tar.gz"
  sha256 "b728068904ba43f32efadaa7957044c3d9603648e125566ed11daa50c677f89a"
  license "Apache-2.0"
  head "https:github.comblockgoose.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae3a75e773c901fd0b10b25d39e8af14f2ddeded6d7285496457bd5d5f9a700d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dca0464557c380f7041730c8584a9b91d795e2b11e07bc71afdbb74ed2cf80d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28a8b94581a636e211b3b535667a860e590c608484d0dbfc9e3cf3118ee3d2fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2210c348658c0dd9ce7c74693a7508823ea674b6a844d2e5c89ce212c4566c3"
    sha256 cellar: :any_skip_relocation, ventura:       "3f9907cfae0c94f2435cf549090978d12602da2302f9a4a2a11d4fac3fbe61e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45e8825157f2f65b1a5d5988ffdcfcd0480a7aaf3ad8b3d95a49c3d1795f1492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1b8f38d21c50ebedf9b74be0483ea506eefc56d6e434363a8c76692dd0a2084"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesgoose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goose --version")
    assert_match "Goose Locations", shell_output("#{bin}goose info")
  end
end