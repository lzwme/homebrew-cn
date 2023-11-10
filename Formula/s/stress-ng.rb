class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://ghproxy.com/https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.17.01.tar.gz"
  sha256 "b628409c1934bd4f0ac4b390a5253d383ffb8f962931379c7fb9bb2852ffcbe9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a58c20cfc6170ec8883b9ada01549413ce3bc85edf0fcc70b728472abf9aa919"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43a2ace414552b0929393aad78cee087844181f4b92cfa989dc79a8f34bcf437"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd799dfaca7f719a03ce75e213684558bb43388a5f3408cb90d2a339d44310f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "14bb1ecdac447e03403882149c6f6da0acb9f0592347ba38cddc300143bca4f3"
    sha256 cellar: :any_skip_relocation, ventura:        "db99e9b2c780cf55aeeb944b3203ec06a44deb7eab4504e218ef5847d2c398dd"
    sha256 cellar: :any_skip_relocation, monterey:       "971f3719099202175153ed79e47fda4646107aad93157de99ad4fc6e1a2beed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7a6348efaaa11aa66617b5a078e507d6ba2071234bef89c2413932831070a96"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end