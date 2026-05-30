class Nixfmt < Formula
  desc "Command-line tool to format Nix language code"
  homepage "https://github.com/NixOS/nixfmt"
  url "https://ghfast.top/https://github.com/NixOS/nixfmt/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "db202a4be0d773def5c97ce16bb8f02e99406264ccaaab2cc84e642296ad0c54"
  license "MPL-2.0"
  head "https://github.com/NixOS/nixfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5e4d38f05567e78c6a023e449c6cf6b44cc579c3e023be120a0477cbff8fc4a0"
    sha256 cellar: :any, arm64_sequoia: "f346debad05bc3a16e66ae666f1857ace15e723c44189416b6fb6674679a8ce4"
    sha256 cellar: :any, arm64_sonoma:  "cb9249a6ad498ac8ff92b9e0556be6066d7d0ce26628674ee0674cf42e657a03"
    sha256 cellar: :any, sonoma:        "bab8f87fd704af52153b67bf16938d84abb12f87e57b7f390a062c170bb14fe3"
    sha256 cellar: :any, arm64_linux:   "58ca44fc9a7e5d74564fc1066c47b38ce3485f95e3a6b36f190eca9b11c9b61a"
    sha256 cellar: :any, x86_64_linux:  "48371ae96c58fcf951df92d872b18913aabc54e98a592e32df9806bd614ec037"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_equal "nixfmt #{version}", shell_output("#{bin}/nixfmt --version").chomp

    ENV["LC_ALL"] = "en_US.UTF-8"
    input_nix = "{description=\"Demo\";outputs={self}:{};}"
    output_nix = "{\n  description = \"Demo\";\n  outputs = { self }: { };\n}"

    (testpath/"nixfmt_test.nix").write input_nix
    system bin/"nixfmt", "nixfmt_test.nix"
    assert_equal output_nix, (testpath/"nixfmt_test.nix").read.strip
  end
end