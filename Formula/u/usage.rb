class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv1.4.0.tar.gz"
  sha256 "7c1db09dc06ef4d54d4defa24c22a06ca973ffb46097629485814c14e717838b"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fa471b341b76f1aba01704afc777065a69d1ff65f2b92aa5092260c7bfa4ed4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "481478664defb24e1bac2830b0ec6650c4f625671442f9a3ac86da6fcefc3883"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af7f82464348ae8ac5b4773d6402deeab6147f455ab1508b01502547e2b541ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "d24eaaedc6a4ff9de764286e5d538d6c009e055a11cc2f253a70a043cc3ffc51"
    sha256 cellar: :any_skip_relocation, ventura:       "69a5d124e1dd0c3a601e52b67323b8b331f8b4d239cc1952715232a0d12b6516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e866d68719f359b8e16f780856f7318e832c4d8a6af8185a77bac3e0e995969"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end