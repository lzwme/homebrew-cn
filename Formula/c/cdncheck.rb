class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.33.tar.gz"
  sha256 "19ddaf6b132409826211fcb837866d555aea967529dfe4eeae388d60dfbb14a8"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a91d40e222112dfcecb79465858d135d7ac4ebbc52e7f6a0698f13aa06b0b04d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "791aef82eeb4fb7276a84fa9226d36cac1d66e6063e3cbb2aaad866c2542d879"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa475f1412c91499e4bc716bf0f51b7fdfdb1c04f578c8ab30f094eb367bab47"
    sha256 cellar: :any_skip_relocation, sonoma:        "96ab991507cdd9bb3bae2b8376d7bbce89e5b90ce9894fbb384a87a1f2ddad1d"
    sha256 cellar: :any_skip_relocation, ventura:       "3234dfd958d6f28be654533bc782fec3091d24cf9af39079d9daea45755a527d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23dde4563610e03121756c2e521ec221c288b556e8915f9a0221411679ab78ea"
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