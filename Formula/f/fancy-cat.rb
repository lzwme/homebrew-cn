class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https:github.comfrereffancy-cat"
  url "https:github.comfrereffancy-catarchiverefstagsv0.4.0.tar.gz"
  sha256 "bce101d5eb009ec9057f7b87f6ad767ee96238abcee8854a9db7febd0229a2bf"
  license "AGPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c50dc8dd4c720dfcb0f1704f279dba43e6f09b0bb9b8168c7f6f8ccfabc2a7b1"
    sha256 cellar: :any,                 arm64_sonoma:  "e5ff13678c504c11f29b56c77a634e2559cd9a00f5a572b888a5ebda5d56572c"
    sha256 cellar: :any,                 arm64_ventura: "6200d24bc2acaf506ae0b158052153f8178063a632dd8a84d924059650ca48e5"
    sha256 cellar: :any,                 sonoma:        "f9905f726ce37d39ef711daaecc42e1c6ddeceb2d8b48dc9a60084aa56de01fc"
    sha256 cellar: :any,                 ventura:       "03fdd754526a9ae43987bf9dd6837292889ab187d024afa5fb9bbef618609d88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e84a012f6222be6d9b589a909fdf85a895f7c0fe03b1d7ef18b6c37161c92302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d95a8c66f63caab178335f3f3a8c722f6e4a265da8881f8d3da77dfa370aea7"
  end

  depends_on "zig" => :build
  depends_on "mupdf"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https:github.comHomebrewhomebrew-coreissues92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *std_zig_args, *args
  end

  test do
    # fancy-cat is a TUI application, unfortunately we cannot test it properly
    assert_match version.to_s, shell_output("#{bin}fancy-cat --version")
  end
end