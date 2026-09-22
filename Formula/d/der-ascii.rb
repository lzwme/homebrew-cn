class DerAscii < Formula
  desc "Reversible DER and BER pretty-printer"
  homepage "https://github.com/google/der-ascii"
  url "https://ghfast.top/https://github.com/google/der-ascii/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "4335ed4f0229d0452e6a8793ce25d45d3fe633ff388f08cfba422d50a009a005"
  license "Apache-2.0"
  head "https://github.com/google/der-ascii.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c26d32eff2a2323d6c7a5b05fef68e6b1801885b94aa085f87fedaad8237ffeb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c26d32eff2a2323d6c7a5b05fef68e6b1801885b94aa085f87fedaad8237ffeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c26d32eff2a2323d6c7a5b05fef68e6b1801885b94aa085f87fedaad8237ffeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9a8681211a16239baec5b8f3b968041389dc2dcc1558d1c7b3fbe95b076f1d95"
    sha256 cellar: :any,                 x86_64_linux:      "197939e5f08db8c574335146e29d969a0de4ac4fd6d6c7f724d377ccf32cd28a"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(output: bin/"ascii2der"), "./cmd/ascii2der"
    system "go", "build", *std_go_args(output: bin/"der2ascii"), "./cmd/der2ascii"

    pkgshare.install "samples"
  end

  test do
    cp pkgshare/"samples/cert.txt", testpath
    system bin/"ascii2der", "-i", "cert.txt", "-o", "cert.der"
    output = shell_output("#{bin}/der2ascii -i cert.der")
    assert_match "Internet Widgits Pty Ltd", output
  end
end