class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://ghfast.top/https://github.com/vapoursynth/subtext/archive/refs/tags/R5.tar.gz"
  sha256 "d1e4649c5417e671679753840ae0931cdbd353a862333129d7bd600770fd3db8"
  license "MIT"
  revision 2
  version_scheme 1
  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "dc3a3b0bbe86e9002719ed243c5e06c4e0b7264ec2981873f1fb7a2435f6655c"
    sha256 cellar: :any, arm64_sonoma:  "8f8fb2470401d82aa19f72b3c8762da0626afc1cbfa6e1415c79505a01e827f2"
    sha256 cellar: :any, arm64_ventura: "b8f5f2b5924b6cfe30971a4048af1a317709864c0e97dfe056a1fff0c2de733d"
    sha256 cellar: :any, sonoma:        "757db63885fd16e48acd8e0c2d3b20040ec81a43c8a0cf4df64e7edc36068c17"
    sha256 cellar: :any, ventura:       "5ebd9057c6fdb0b330f2c5e833b762f5f15f63adda79c8e9b1c064189c65ece2"
    sha256               arm64_linux:   "13dc72e858111a297be71c83e9b38527532cacbc0ce3cf70c99f7244e9bfbbe8"
    sha256               x86_64_linux:  "ec2c94f30b72c1169ca23e5d84c2e9340c656250e01f0ace66c7f756a67dcc13"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg@7"
  depends_on "libass"
  depends_on "vapoursynth"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "install_dir : join_paths(vapoursynth_dep.get_pkgconfig_variable('libdir'), 'vapoursynth')",
              "install_dir : '#{lib}/vapoursynth'"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.sub"
  end
end