class Q < Formula
  desc "Tiny command-line DNS client with support for UDP, TCP, DoT, DoH, DoQ and ODoH"
  homepage "https://github.com/natesales/q"
  url "https://ghfast.top/https://github.com/natesales/q/archive/refs/tags/v0.19.9.tar.gz"
  sha256 "18a68f067daccce97f2a7e4ce4c72e206eba03a1c57040f8c7488f100040d2fc"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d601d03915b15c3729f1b1ce5d1f1e5a2d59cb25953cae53d1d2e8354899115"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d601d03915b15c3729f1b1ce5d1f1e5a2d59cb25953cae53d1d2e8354899115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d601d03915b15c3729f1b1ce5d1f1e5a2d59cb25953cae53d1d2e8354899115"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4dcaa7ed1d6a1bf6d852a5b98feb09d613452685f2e35c6536e23b1aab881b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30281c1a7141b9e26ee5c9ca5695c167341d6ee46809e8373dcea5a4f9788fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d99cb88155b05dfea7798eacf2aba53dbb764aa2ca87f3fe249fab5e163482be"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/q --version")
    assert_match "ns: ns1.dnsimple.com.", shell_output("#{bin}/q brew.sh NS --format yaml")
  end
end