class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https:github.comfrereffancy-cat"
  url "https:github.comfrereffancy-catarchiverefstagsv0.3.1.tar.gz"
  sha256 "818650bd3c5c1d3aa3a573d185a49ea3466bda86d3e659965941887b424661d7"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2168063861e16f7c8e6a59934252274ce8cefee07a11aa1cadee1ff823b7b20a"
    sha256 cellar: :any,                 arm64_sonoma:  "ec416117eb9115fddb92ff7b546bc64d86a4e1627acf3c41ca96d4d73f0799b7"
    sha256 cellar: :any,                 arm64_ventura: "e81fe6d6a16c3b59f16d14e2c5cc699ce3780d74d737b97883163c226758611e"
    sha256 cellar: :any,                 sonoma:        "9b6ebe97aa70c3ef8244ac046eac44ed907ba6326e3c311e7b944c6561cf8f6d"
    sha256 cellar: :any,                 ventura:       "84135af3ed3934774f5b9500fec41f3e02b25477efaa8e8baa8c04e63a8722c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3490ee5ac7f87a3d84540f573c07cef898ee4c6172224e6226ac2cf015683564"
  end

  depends_on "zig" => :build
  depends_on "mupdf"

  # version patch, upstream pr ref, https:github.comfrereffancy-catpull68
  patch do
    url "https:github.comfrereffancy-catcommit817906c7a08907da1acc4a436acd2650d5e7ba72.patch?full_index=1"
    sha256 "ddb4e776077b9b7d79eead905964a95c790a75a2c1bc8f43b86dfc814ee5de27"
  end

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https:github.comHomebrewhomebrew-coreissues92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
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