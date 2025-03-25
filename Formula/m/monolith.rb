class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https:github.comY2Zmonolith"
  url "https:github.comY2Zmonolitharchiverefstagsv2.10.0.tar.gz"
  sha256 "251d6d3cc8732af47911b2d2a6bf314953e38aea423c54b83404dc16576554c9"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9fbf9b7e8db78e2bf836ddd5c83c117e8de611b3e087dc210db86b355a124ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "208d53e7dd2acfcd60c2187873050cd54e3beb551ca74f1c8fe357a328f6ce37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96b56bcfb8d2fd27f8e66595228ea4eec7aa203dd8f456cb649743a031eb9a8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "588db82f13cdc1239884532d5a21f0351ecfee5f304c680bb28173597c03b3f4"
    sha256 cellar: :any_skip_relocation, ventura:       "13d4559eb65343d5b482d367a88a4eea07a47cf533a7abc95a1efd2860c3a6e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58ee2fd3f6f16631fa1a0f425f5737e78402559144e987276439e049ee87f010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f56071cc530229e72959da558274aa22dcad7ed07d3d2ae9c33ba330d5388d4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin"monolith", "https:lyrics.github.iodbPPortisheadDummyRoads"
  end
end