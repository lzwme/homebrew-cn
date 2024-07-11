class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https:printfn.github.iofend"
  url "https:github.comprintfnfendarchiverefstagsv1.5.0.tar.gz"
  sha256 "9862150c735ae19cc4cb75b4944c23a81b43de807dc771ad83be414bb38c7214"
  license "MIT"
  head "https:github.comprintfnfend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e70277d59c2bf8169e1500b75eeb5d4924e0c3c1c60b1a7cdb1fc786f9850c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "661c9a5553b6465562816946c674385fc5568276a60e40cf73135b7d4127206e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4af69264896c729808fc4c55c5702200b033198f5552cbad2bc8b9f827867e8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1b1a4c1d239ca44286cf0567b4290cc7e34e700f16e80df04f2c1635fec87aa"
    sha256 cellar: :any_skip_relocation, ventura:        "deb76cdea1222c479ebc81e1593c1dcca13b2c0dd934d1f377989fe55b39569d"
    sha256 cellar: :any_skip_relocation, monterey:       "7adb56c050ad274553a25e5d55d6699f8f566a07a86819875e78c45aa0ced8df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce66ad8ef54bf901896b0df3e3d0b71f5e1742784eafdcfde77944d78a6159b8"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")
    system ".documentationbuild.sh"
    man1.install "documentationfend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}fend 1 km to m").strip
  end
end