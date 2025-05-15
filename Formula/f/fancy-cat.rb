class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https:github.comfrereffancy-cat"
  url "https:github.comfrereffancy-catarchiverefstagsv0.4.0.tar.gz"
  sha256 "bce101d5eb009ec9057f7b87f6ad767ee96238abcee8854a9db7febd0229a2bf"
  license "AGPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1da7dddfc4b9515f7354fa7f567bc9b9ba5a7c8875c0b5989fb93bfd862e0693"
    sha256 cellar: :any,                 arm64_sonoma:  "02a59e205ad0181707f8ca1d27d57301639cccf7ff582d9ffd670cc52208bc3e"
    sha256 cellar: :any,                 arm64_ventura: "779b41983cafcbc24c6de0abb09a6262a1fd4be12b60c368fe5b0af9255379df"
    sha256 cellar: :any,                 sonoma:        "7a3197ac9a138f73c9733fe33320c651d1658b5497ca943e639f343934966609"
    sha256 cellar: :any,                 ventura:       "a7c5bc96d9b96dc33b7af7048b207f1ef3408fd669486e97b224b0561d45699f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70d6755d7cfead91343a9d2bf20d52b599a1ffc0004f13b229bbec33e00c4124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa0b88c1cbdb1b01125c1b51b1802c0993579148ef513546dd0b419c706bc3cf"
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