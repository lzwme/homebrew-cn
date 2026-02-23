class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.24.tar.gz"
  sha256 "fc01b1ecd7f2578946d92fc91e4dfe666f94ff8cf51ae73fe2284201bb5c5f51"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36029c3189d714c8ba147a9874bfb69a30d748d930060fdd83e289cd368661c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc0233134cb66fef445fccbafb27c5c4c4c4ee5532e0ee53ebff9464e364de60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6092b7e01ac0afb848b498a5ef373fa39d54d631ad70d6855ff38921e33d3a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e953e141cb79807c662528aaebd49556e59b94dbbb1bc6f866879c23a4257210"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aeff239013bf9e2e4f434713388eee9cb67681d97d7ffcc9d2f88df2af44c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf564e3ba0c9963f7373ae8732e9b26530a44e525956dad19d20268ea537cede"
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