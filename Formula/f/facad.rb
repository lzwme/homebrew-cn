class Facad < Formula
  desc "Modern, colorful directory listing tool for the command-line"
  homepage "https:github.comyellow-footed-honeyguidefacad"
  url "https:github.comyellow-footed-honeyguidefacadarchiverefstagsv2.16.0.tar.gz"
  sha256 "6cf3963807c038b34c87c57535b3a0f0949211af4dd6f5c477ca477b2a33232d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "499a5ff9653b60e5d3c7b15ee1d8f1bfea6ccb8bcf475c3328f0dab1a3f7749d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9915b596c25f62e7ab0d7b0bbd6041f32a27f464c13cef51addad0ab5020312"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cf1da0a282d4e1a0bf31c598c32db9a6a4e3951e1a2fc2c30e3f0acbb4599aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "b363eb1e46b109bb18f46070f270b321212d0dbfaf94c45225fbb0a5d14d5f40"
    sha256 cellar: :any_skip_relocation, ventura:       "f42572f8063a0f5310fdd8e59808760e181e26c2573fd47ae3b2c61c9cbe5ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e670c18d58062da8f93ede3e9e58931495f91b5066d1e85154b1ff152ffd3380"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "facad version #{version}", shell_output("#{bin}facad --version")

    Dir.mkdir("foobar")
    assert_match "📁 foobar", shell_output(bin"facad")
  end
end