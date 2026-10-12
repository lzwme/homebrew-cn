class DerAscii < Formula
  desc "Reversible DER and BER pretty-printer"
  homepage "https://github.com/google/der-ascii"
  url "https://ghfast.top/https://github.com/google/der-ascii/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "bd1a4d6970d4ed9ec32541bc972ddc7dc64ff9357faf567f30bf1367159daf70"
  license "Apache-2.0"
  head "https://github.com/google/der-ascii.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cee7ca36c243deb8b819de10afba2487850508083edfddd0c95b52a9a44d8934"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cee7ca36c243deb8b819de10afba2487850508083edfddd0c95b52a9a44d8934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cee7ca36c243deb8b819de10afba2487850508083edfddd0c95b52a9a44d8934"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4707560a4961c18efd63cf9167f18be7cc96fa96252703a510d40979cab27dac"
    sha256 cellar: :any,                 x86_64_linux:      "5a6169c18276048b713584fb4e9a55f13bb7ca6e02d7063319734b715a1f8461"
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