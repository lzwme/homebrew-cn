class SequoiaSqv < Formula
  desc "Simple OpenPGP signature verification program"
  homepage "https://sequoia-pgp.org/"
  url "https://gitlab.com/sequoia-pgp/sequoia-sqv/-/archive/v1.2.1/sequoia-sqv-v1.2.1.tar.bz2"
  sha256 "a25c7e829122f63fc1b849ecf9a139baada4bc0d9ca622caf3e479061c4fe33e"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sqv.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f3827f8d3c4c492626dd2c0624785155386ec840f2ba5dbeccb2deb4e966e88f"
    sha256 cellar: :any,                 arm64_sonoma:  "dbdfd98fef0e52a320ac7b64fc80d4efb48901358a2a611473bb0f75cf81132b"
    sha256 cellar: :any,                 arm64_ventura: "3226917d3d0962b71c1535d0bd75b61b5fa0e5c9d9c117d763d049e805a828f7"
    sha256 cellar: :any,                 sonoma:        "f4f5aa01598d237122fe97b9fdcc3dc7f134d92cede582332cbb45c72ef1c12e"
    sha256 cellar: :any,                 ventura:       "6d3f5df13ec2788b622cf376aaf7ee0291f26f0cf957d33ee24c1469282724b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e251eb84cdfd26d119bc094ad99074f3f0b0eecb32742451044d92daf8a30c46"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "gmp"
  depends_on "nettle"

  uses_from_macos "llvm" => :build

  def install
    ENV["ASSET_OUT_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    man1.install Dir["man-pages/*.1"]
    bash_completion.install "shell-completions/sqv.bash" => "sqv"
    zsh_completion.install "shell-completions/_sqv"
    fish_completion.install "shell-completions/sqv.fish"
  end

  test do
    # https://gitlab.com/sequoia-pgp/sequoia-sqv/-/blob/main/tests/not-before-after.rs
    keyring = "emmelie-dorothea-dina-samantha-awina-ed25519.pgp"
    sigfile = "a-cypherpunks-manifesto.txt.ed25519.sig"
    testfile = "a-cypherpunks-manifesto.txt"
    stable.stage { testpath.install Dir["tests/data/{#{keyring},#{sigfile},#{testfile}}"] }

    output = shell_output("#{bin}/sqv --keyring #{keyring} #{sigfile} #{testfile}")
    assert_equal "8E8C33FA4626337976D97978069C0C348DD82C19\n", output

    output = shell_output("#{bin}/sqv --keyring #{keyring} --not-before 2018-08-15 #{sigfile} #{testfile} 2>&1", 1)
    assert_match "created before the --not-before date", output
  end
end