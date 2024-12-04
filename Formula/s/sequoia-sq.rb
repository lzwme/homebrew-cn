class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v0.40.0/sequoia-sq-v0.40.0.tar.gz"
  sha256 "6693d80f49e154a3588a3b64e4be06cede672f50e45be1a5ed3fba54f9a8126c"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3fac93ca2bb7a6348a3fd7f1100f1c335ff48cd7173ad47ef2fe0330e9a887bd"
    sha256 cellar: :any,                 arm64_sonoma:  "07baa5acf2547df62f8e6c4f1c610ca71480dc97fb792c0058918d18f8b09eef"
    sha256 cellar: :any,                 arm64_ventura: "bf353434f652a94159f6adcb693f70cf849a80d305d2d926cdeefbefc3635aef"
    sha256 cellar: :any,                 sonoma:        "ec227ca13fa346310553e882ca6e6f8bc1223c6862445bec6e56b8bb281a5e3b"
    sha256 cellar: :any,                 ventura:       "35d356a6cc597808d8f87966561ed5c5598ed31991cd3978f06ddb72bdd0a3c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49c18199b3603cd9bf15c9bc706512a53f5f7b266e3d67ea6525afdfa83d44c2"
  end

  depends_on "capnp" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "gmp"
  depends_on "nettle"
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["ASSET_OUT_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args
    man1.install Dir["man-pages/*.1"]

    bash_completion.install "shell-completions/sq.bash"
    zsh_completion.install "shell-completions/_sq"
    fish_completion.install "shell-completions/sq.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sq version 2>&1")
    assert_match "R0lGODdhAQABAPAAAAAAAAAAACwAAAAAAQABAAACAkQBADs=",
      shell_output("cat #{test_fixtures("test.gif")} | #{bin}/sq packet armor")
  end
end