class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://ghfast.top/https://github.com/googleworkspace/cli/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "453914eca7626a5097227b93dad76b4dd5d9d0b8bae8e35684ec54f33b122718"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de5bf13bd334ea2618b98735fcea2b8bb61f608a02c8a764c56161b359596b81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b1cee5b8aadfd3ef47b75f1bbcf8f141e1a7e1fd2dfcb180db5719d14a54d7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8684c430dca71ae70f7e7d25ee633ac91b04f3773e1c4640c506294325fc595"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2d8a563a428458fa9ea67735e3941fafe9354da7269b9184c6d2c62599b1a45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83dd91bfbbc63bd8b42470dd709edbc7643dd5cbdf1014b377ae59bc3f538f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "395ba8a2720983cd852ee04d316df1b3b6e14ee20007ee0497ec87daeb4ea0ea"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 1)
    assert_match "Access denied. No credentials provided.", output
  end
end