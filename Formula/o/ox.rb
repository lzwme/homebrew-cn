class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.6.9.tar.gz"
  sha256 "f6af867df036f08bb50b4db3d7ceb9d98861fa2f5e3003f91c97d596d06dfc6d"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c355a0a67b1868bb40f1b2bddf45366d4b2d6ff7906c2f3c7c4524cd9a2bbc61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66be2a7f36454a43d678fe1462ef86eb1d0b9ea051f34f506b086770618ddea2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dab85e908a55fe669e7076b81c6e3bab1f2366184912cbd8266d3541617706ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "402ea5444332abc0d99dda2aae5ba622793dce9cb6ea54c3dee7b954786f6137"
    sha256 cellar: :any_skip_relocation, ventura:       "828d1ea19921cda2a8777ba9972a4c728be4f54cd1c96b60563c8d2fa2f9cf98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6efb2787d31b2490c431c8246979c2e9d3bad327188f4c1fffc64f6f79e8dc8"
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