class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "1e7bec38a6a7df786de3a373937d7845673021db7f2364b37af826cfe75109fe"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c22cdb401f5ee18f88e6796788aa42ccde69f1154a364016d462fa3e3298303"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae211c1bbd77a193000e94eeae9e628463de4d01457bb7171ed519e952c93599"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a25ce1a32030a6ff593807ee231d998a58dc4bc5fbfd18ebdfcac78cfff0922"
    sha256 cellar: :any_skip_relocation, sonoma:        "1db7e4139539b068f58147f9a1ef5612c4efde61763a7679cbae583c2a273145"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f420d80e0acfa31cd078689bbdc17397450a0494b8ba178e939e3a865c647aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "060b0c23b1b3e9f927c0e60099ac42e4705c155ea81ed3fbff10553ea1304934"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end