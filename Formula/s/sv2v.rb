class Sv2v < Formula
  desc "SystemVerilog to Verilog conversion"
  homepage "https:github.comzachjssv2v"
  url "https:github.comzachjssv2varchiverefstagsv0.0.12.tar.gz"
  sha256 "b64312c995f2d2792fbe610f4a0440259e7e2a9ad9032b37beabf621da51c6da"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b3b60e445a1391fb5155d3e745f2e53ae712e8e36d93340597e3dc34fdf6c6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3f220b7b729109d382b64888eb876d54c5cf37089cfd3579fc441e4dd6c35a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da6d7bfa9beabf5db683cb311da63880d9402171ab76cd576e043f0c86fe5fa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f31c05a6e0c9c7cfc27667d23a0a26bb2f58ac23a9123a022ec88f36d93df196"
    sha256 cellar: :any_skip_relocation, ventura:       "6ad398d9d6778c71e2b31c6aefe8a85400c3630be54be7d4d651c2c450e9ba52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e5ded89060d8e416910dc0538759d5e9dc1cb074dcc6ba2d21bc98ecb725161"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sv2v --numeric-version")

    (testpath"test.sv").write <<~VERILOG
      module test;
        initial begin
          $display("Hello, world!");
          $finish;
        end
      endmodule
    VERILOG

    system bin"sv2v", "test.sv", "--write", "adjacent"
    assert_path_exists testpath"test.v"
  end
end