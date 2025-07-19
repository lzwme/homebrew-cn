class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "643dde33043ba0995ef92a97343b58902b0059e5ee7447c6ef70f1ac7fb0d8f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8205c268eb6fa1a6602e03c6fdef310faa23896a11a149997b338bd61406d0a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91e788a796b0b4c3e16a12f45be9f26280888128216cb95a2015536afb9e65ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c28debc9599bd2c772922239bdd179b8f433ac404b9d34079c0bf24741da2a22"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1ab8e9422e78b3dcf652014e1115fea3e943e1f244e909c4e7d66f93a36b158"
    sha256 cellar: :any_skip_relocation, ventura:       "b41a01cc731e4a514ec009ed5fcb4d1c3fe29c84aec8adcaa29255742986de90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "600f13a45608aed3b43d7712ac81ce6a32d2b6ae7eefad45506fd7d52581c30c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bee7cd3355d90b57c41722b28b84cb60eb4fed11132a73301858952a37c2276"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end