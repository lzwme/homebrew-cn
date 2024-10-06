class Facad < Formula
  desc "Modern, colorful directory listing tool for the command-line"
  homepage "https:github.comyellow-footed-honeyguidefacad"
  url "https:github.comyellow-footed-honeyguidefacadarchiverefstagsv2.4.0.tar.gz"
  sha256 "8aceff955605d6422812935288b441b1d836389739587d0f2f820ca5ffc45dfd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e00f93d99495b07272b837b221f849e7637406e04f1ad74191efa4877091877c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17818462146323d92d9cf48d91834b9b97c19a9060c50d17b0c1860390744c0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "932634254b086f885c9aebb8e887e567a281984076c7f1eb5033d37e43fa9c80"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0b9cffeaf269f5f49f8c544901dd25d6ca3838a14d1aa69e237ad6c1fa911a9"
    sha256 cellar: :any_skip_relocation, ventura:       "cf304e3b0843c5a63803120c889e907496bea65fbfe80709e859fdc0c2106e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1026221b98afeed8398b2ac1dde152648fb08569ad519a054942a74deb4f3ec0"
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