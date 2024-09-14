class Pivit < Formula
  desc "Sign and verify data using hardware (Yubikey) backed x509 certificates (PIV)"
  homepage "https:github.comcashapppivit"
  url "https:github.comcashapppivitarchiverefstagsv0.9.1.tar.gz"
  sha256 "717b4ffa8d74e1bb0d7f2f6248bc1b599f1d2f26535cf87d8d362b056527dbbe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b25623984260c936d7273f3a364c96c68ab7641e64da7f2b417fa5c9dcbb55c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ae035fe7572033ac646c7def4bb127b88cf43ec0b5396f66ca90b20c062accb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c3d2c932012082cb53c0c9fe0f623e766873aafc218b9e134f20a59e00f14b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "310d4a4a653caf261a9e90a1c5b7b43d5a27fc0c40732e796a2955313ad829f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b446e7bb2ad55eacb7b6d782b589f2e53781d4b8db4d5fef07df2ad3238c77ce"
    sha256 cellar: :any_skip_relocation, ventura:        "8bb6f0c211e41618b84df3d06e662daf61db730f8687a62450326a01f7f56bb1"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3bfac9227e169a051bdeaeb331abc24ea62aff5e1a9b284d9994b16d8fe839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7054a630abfaccfd742ea105a4122d390e19a5c866a3ff98d173e51793e379b9"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pcsc-lite"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args, ".cmdpivit"
  end

  test do
    output = shell_output("#{bin}pivit -p 2>&1", 1).strip
    assert_match "the Smart card resource manager is not running", output
  end
end