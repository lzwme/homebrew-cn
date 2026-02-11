class CodebergCli < Formula
  desc "CLI for Codeberg"
  homepage "https://codeberg.org/Aviac/codeberg-cli"
  url "https://codeberg.org/Aviac/codeberg-cli/archive/v0.5.4.tar.gz"
  sha256 "dd19f9b4ada8759b8736303c24a04bc5c697d2ab72f8bbcfb13e84899cc6f635"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Aviac/codeberg-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "033315b17a329e110e832830faebc1f5f851836a43ef102f43aa4a6cebf4fab8"
    sha256 cellar: :any,                 arm64_sequoia: "2c34877c98d866a1fb1623327f5209af1b265c21d522f20486d3c0cc5fa84d40"
    sha256 cellar: :any,                 arm64_sonoma:  "ff22f53060fcffb84877fb52a2333cbfca318ca986404ea49bcb2f5977e32a2e"
    sha256 cellar: :any,                 sonoma:        "3937bdc85512ea4c2f693a3972d2743e2b0ff809c547da9235b781d0a5435a20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94b0591c36b8fd02f03f0d413cb8ddfebc9a6ae82baa2a5315e9e5b73aec1d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7827be943f3bb7aaa182a8f617885baebf62947e7232c3f638c74cb4c0d84a9a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"berg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berg --version")

    assert_match "Successfully created berg config", shell_output("#{bin}/berg config generate")

    output = shell_output("#{bin}/berg repo info --owner-repo Aviac/codeberg-cli 2>&1", 1)
    assert_match "Couldn't find login data", output
  end
end