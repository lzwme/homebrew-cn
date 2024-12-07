class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.7.4.tar.gz"
  sha256 "a4720cf30cd2a48ca796716fffdfc5d94199c0bcd2e7976212be70865250d52e"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e0486de8c9bf8ea626488c8f9d82fa6a82ad41f74bdbc4b0ae4b6f8d65823d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a74605375e1344f7df05c3fbb357e68696d0ce6d067e375eac568e8779420de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87a45aeca8a46ecad7942f7112054d7b12c0d5833913450e88c0ffca75c072b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c38de0d21a445a0dfc705616d6836c1e2d7471f3e77f2f15647ad59a5ddf790c"
    sha256 cellar: :any_skip_relocation, ventura:       "a7bd9ba319b294bdaad0cb7109d828128b9e5ac73b3ce9dab01059ee485c15e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4849f3e2f54e2faeb5f014543546185dc8b694e3bd74c4cb0b5f8aa4d2966f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ox is a TUI application, hard to test in CI
    # see https:github.comcurlpipeoxissues178 for discussions
    assert_match version.to_s, shell_output("#{bin}ox --version")
  end
end