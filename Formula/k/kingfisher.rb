class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "93ae7dd327a0bcfb9e6c4db04378730d0d0afdc669771a8808539bae99f38d21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32277145ccb4729c48152b158e4facf31835a7ec12cc49d8a1147c15b1b38890"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ded76a825cd185f5dfb3c7061287d220bc7c9d96d513cf55a2bf787a0759339"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc57770bcad048951adcf996d7f973118e6decb62b567dd02530851e6afc8167"
    sha256 cellar: :any,                 arm64_linux:       "d854c13fc51f166f5f541ca935d34c17943ae4da5340f9096b72324710c76756"
    sha256 cellar: :any,                 x86_64_linux:      "e4d0d649c3b5da5229bc4ef7fcc2aaa466b844b70d08d5aff589b2d430e2ebfc"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end