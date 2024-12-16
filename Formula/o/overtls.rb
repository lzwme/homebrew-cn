class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.39.tar.gz"
  sha256 "eabf8c7ee43cb365fa532e22b022b7d99ff318af0e6923da891cab7ea82e5b06"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "314b21cc444a12c55893375c640a2c7221ea2221aaee99b8d40a4f31f1a067a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a6a52c4cada416a6904c7fb8515e87c20247ed44216a3c46288194bf6e924fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba1df3525e867524e376e2bd7f2085962661364087022f1a24042bade26c198c"
    sha256 cellar: :any_skip_relocation, sonoma:        "537b95a134eb8f7335ac1097bfd1d2b54df85a98f0e54f3e7e5966db5aafcd41"
    sha256 cellar: :any_skip_relocation, ventura:       "08beeddd21f9e7c35085edf14f27436e8cc9791580545c89844e76527a73f68e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e387f0c3d5c5e12fa22bbed2a047bdc049b721a577f627e9c90e0fb65164bf46"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}overtls-bin -V")

    output = shell_output(bin"overtls-bin -r client -c #{pkgshare}config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end