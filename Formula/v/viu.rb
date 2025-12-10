class Viu < Formula
  desc "Simple terminal image viewer written in Rust"
  homepage "https://github.com/atanunq/viu"
  url "https://ghfast.top/https://github.com/atanunq/viu/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "2164d8626b8210227ded514a0ca18fc4092571e174f55905facd33837fe2eb4c"
  license "MIT"
  head "https://github.com/atanunq/viu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93ff90ee7619a419e4720526410e5dda4c14929b60abb920a0aab85e106cf1e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fe76ca4a5b5f6f6b9e7250b70462de490afe80535377f2274d175e5937fa3f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9722eef67e4a78c32942739a8a2fad4c9fb425bc7674ae55bf26cc2abf66cb5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "760fa5030f8b25d73fe32fb7b7e86938f85e5246e35326da2648b8855dbcdbbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf216166b051365b76e70b12d5236a3c5895afaf89f1b9c36881a2c3b3004160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4afea7f9773028a278631b5c47191d41ca30ba5decd34593a0e4c8a53a9312e7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = "\e_Gi=31,s=1,v=1,a=q,t=d,f=24;AAAA\e\\\e[c\e[0m\e[38;5;202m▀\e[0m"
    output = shell_output("#{bin}/viu #{test_fixtures("test.jpg")}").chomp
    assert_equal expected_output, output
  end
end