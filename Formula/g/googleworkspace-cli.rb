class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://ghfast.top/https://github.com/googleworkspace/cli/archive/refs/tags/v0.22.3.tar.gz"
  sha256 "0cfea71e99c5159c3f30b639670a71e75c31557398e2dfa83ba6f5192555e30a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3c560ccabec785454025f15c68ff3995b0755538f48c37a8ecbdca8bd83ec5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21d484eb2a4eafcf2622f8e2e9e6d92b93b4be70f0ca619380f22b2d16462865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09adac8fdc6ee40a5386d114935d00b5e69e48ccec2c4d683adaf4c05dfd6fde"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb68935c91b19348100ae3ab39b47405b56f068d6ac05757c6e6e677dc22bd84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4483dd7ebd204e52a725ac69f79afabd66080e29e899196dd63529d2a4f5c94c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a27116e80eed6219c175ccbcfc09a15dce76488baa43c6dbbd91d19fbdf3418"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/google-workspace-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 2)
    assert_match "Access denied. No credentials provided.", output
  end
end