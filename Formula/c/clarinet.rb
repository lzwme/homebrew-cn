class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://ghfast.top/https://github.com/stx-labs/clarinet/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "935ad4c43d35c796fb6f546b54b1d85e35423ccdb687279445200959768996be"
  license "GPL-3.0-only"
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af25a3faf7dc101a3506fa71210c63396b8e29f0be8fdb38541671ae47660f8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a33716cfc989eef095fe9b0530d112bd980732a33db88a8677d56908039720da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad7b9c0851282b3441fd6438dd11b2b5f307e9c43436e08723075bb20431b6af"
    sha256 cellar: :any_skip_relocation, sonoma:        "34663117b389ce9154309a9f220ab878d943f75e3006f5cbb90ef0b86bd4f71f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "398cf8101212eec5b0fe5bd26f28686d14440f0ac2bf7441fec54200178af533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f55bd3ebf6592b0974562f5768e27e61475229197b4740f09cd5b51f15373d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end