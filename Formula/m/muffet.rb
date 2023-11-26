class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://ghproxy.com/https://github.com/raviqqe/muffet/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "497f1fb536f62aa5f4b0a9ba924734adf5321c076c98f2fd73200c4095c887a7"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b58f226e3122349a675dd5873eed8e01e4c11886668728f65d2a62e41473c1c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88d4af23073093dc11d87042475128ec5322b3f7c0c3e328fded34f8b446e360"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a6eab6900683e7e195ac863004def2b6a3c3e8a670169fe2e9fd9b956fe3cd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad9d2e7d235f14137260e57dea0b66e355e49cb0f7427e0f63010b9069b188a9"
    sha256 cellar: :any_skip_relocation, ventura:        "78330cae0efb6bd53ff5f04c0a239046e73082d28a9cccf5360c88291346c1e7"
    sha256 cellar: :any_skip_relocation, monterey:       "40957a1d641e270ffa14ef1c9814e80cdd92d2219e27b9453a1ee5abceea468b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2076e785c7c45552e994dc5d56837978f2964668c07e2d1e91c19273a7ceeb2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://example.com/",
                 shell_output("#{bin}/muffet https://example.com 2>&1", 1)
  end
end