class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "ef3f600ad5dc709765486d6639ef8f452e9c8bb90735f382ac1dc301b14bd813"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "208ab2c937648d49afb10ce2d5044081a525f8df9b2d2c038261e5132d5fb202"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9bfa5fa6d832c7038917429571ab9e74cfd213ff3a9b683e4397205672577fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eb3e014d83da50358b78f644729443c987395e1a9be1a2273fb6b39e48a9853"
    sha256 cellar: :any_skip_relocation, sonoma:        "f20e1f657bedfa013b6a437b0cce5ccd89c816c883220484ff5a8f1cd4d300f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99b1da1d93b596e48f2209024f174f44d6c35d64e5d4557dd1bfd5a1a0cacbd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab68afb9236930dc77b3c5e9f7f11b31c3cb8873b9825033c95d1e3bb53e19f2"
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