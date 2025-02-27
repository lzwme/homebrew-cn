class Facad < Formula
  desc "Modern, colorful directory listing tool for the command-line"
  homepage "https:github.comyellow-footed-honeyguidefacad"
  url "https:github.comyellow-footed-honeyguidefacadarchiverefstagsv2.20.5.tar.gz"
  sha256 "592b973a2c889f0a509fb332d6390c36ceed01114e1e6ebe97afbec53f209a1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aff9457ec05764b7e7f78910282e06b3116ffe19805a146aaf6f4df5816d10a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8baaa813307fad605954518d0518d96c80217f9e1a8e435b1018149bddc5577d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42ccecd8c25a8d50b5b2ced3ab619e83353c1f4ad9386974adf3122dc450646c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b2d58dd9aba6ed9f7ea0acc1e6a3cc8d305804442970e84127f9ccd50abd77a"
    sha256 cellar: :any_skip_relocation, ventura:       "9c695fddd8ed8f2f0ff27b97c63fac7620683e7d67d95f5ac296eb5e5da8401b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad2577bf3591cf5d08e4cddd9c67f2c6de94ad9721faa5fb7c944f914eb6588d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  # this patch includes header with `PATH_MAX` macro on macOS
  patch do
    url "https:github.comyellow-footed-honeyguidefacadcommit94defddf0b4c4ee5ba1e81c784d4285b508cae43.patch?full_index=1"
    sha256 "b818ee8f3109b6b483545624cee042c07d25e7b052467ff2de6cf98acb192e88"
  end

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