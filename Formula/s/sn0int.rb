class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https:github.comkpcyrdsn0int"
  url "https:github.comkpcyrdsn0intarchiverefstagsv0.26.1.tar.gz"
  sha256 "cf10bff93098586ba7dd885bf56af489ce0177bd1889a13b004fc38f026e71ea"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a547abaa3d17a2f4cae9faddc776c31076e73d6444d8e44eed29db9a7b702d51"
    sha256 cellar: :any,                 arm64_sonoma:  "3e152a8c520739277a569718374479eab1623e54b7df52a73ac173c11a187830"
    sha256 cellar: :any,                 arm64_ventura: "367b3eb6203589309734ce6419f41f318287dcbf395fd8410e5e61b5b722557f"
    sha256 cellar: :any,                 sonoma:        "b00f3aa80e595baeb07464d03118671e43731845dd141209566869e44bce384a"
    sha256 cellar: :any,                 ventura:       "dafedcdf4f30705f40d806d7725994bdf8fe012caa80591c197049e254e657c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "799345e368ecb3b46e5ce18b62976a75707f78a3e717d33b5524d6af3b3a9819"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "libsodium"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"sn0int", "completions")

    system "make", "-C", "docs", "man"
    man1.install "docs_buildmansn0int.1"
  end

  test do
    (testpath"true.lua").write <<~EOS
      -- Description: basic selftest
      -- Version: 0.1.0
      -- License: GPL-3.0

      function run()
          -- nothing to do here
      end
    EOS
    system bin"sn0int", "run", "-vvxf", testpath"true.lua"
  end
end