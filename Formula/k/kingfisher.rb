class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.82.0.tar.gz"
  sha256 "39fd5dc742af21c214e1f21a6a1b4f93efd166534b45d9dd1441a06fd179efc9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f21b49d6ceb156f112c08bf1a9c6aa380939ceda1a9ee75c079ce6b5573cae70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9431a02f36ec16e3f3a9b8c1702eefd6a67a9081c131e190367797ad37821b0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dd2bd21460e90fd49a5df982b8027bc7299154148c5c87341516144189a6e89"
    sha256 cellar: :any_skip_relocation, sonoma:        "4aba52caadc291dab3957a46ec1fcc78cdf8ad082cf358b95c73a9f6153228bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "160295fdcffc9f5850382b1395b5cb3f9414ee9c0439cb8c6cc909f0a939649e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc28dbcfce588f298dbed0e5dc1207fc8ff4a30c68303e4200c247eb5fe951d3"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end