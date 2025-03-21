class Sv2v < Formula
  desc "SystemVerilog to Verilog conversion"
  homepage "https:github.comzachjssv2v"
  url "https:github.comzachjssv2varchiverefstagsv0.0.13.tar.gz"
  sha256 "4ce7df8c6fa3857da6a2b69343c29e7c627a4283090f2b07221aa9ef956a88c8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49224a9f8e4f1904b037465be2abcdeba583826c51cf8269cb0397413ced8a56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0767a722606d8f2395ed5af345e7c3905d8ea5a5f9c64c81245f6d161f7c4f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "252e933952b8d680607936324cf65e335bf6287c676ec9b99b853a9a4b10ad64"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b210f350cfb69d6df2a46f06277e59d62b0e2310ca52b89de86e57125dda49e"
    sha256 cellar: :any_skip_relocation, ventura:       "ffd19a1ab08b2e06e7d04ddafd34ca60231aa9c591e6c642ae0a2658af2b03b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1718ff41c4a8701aa9b5ef78f9ea0856fa2de5e739237b70e6cb64ce6f61096"
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