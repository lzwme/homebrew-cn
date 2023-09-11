class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  url "https://ghproxy.com/https://github.com/MaskRay/ccls/archive/0.20230717.tar.gz"
  sha256 "118e84cc17172b1deef0f9c50767b7a2015198fd44adac7966614eb399867af8"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "cf1908b3b52c8679134450bcc7b16e7d18303b2674fd4860b656da7969dc88ce"
    sha256                               arm64_monterey: "f8afdcb8187ae0f51c798ea460b021abdee631a4178dc806798a597ab13dc7d1"
    sha256                               arm64_big_sur:  "c966d84260aec4ace69299ca1845bd5eeda3203478db825ba3c137e88dd73cdc"
    sha256                               ventura:        "29d0842ee27560a77272cf09bc20a7133aa3a7c92b82e3e370deb30babd4679b"
    sha256                               monterey:       "cccf7e7ca6a22068c1064201e7b0f6aa07b67dd5bbcb4bd51eb9c71513367508"
    sha256                               big_sur:        "a5bcc838ed9f57144a2983d93efdf89374e65ab88e64dd8862438b1130cd8d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b035a7eb87a37d4d2c15f1e13f7172cf29b2d4ac99c38c28873e2ca1171a9b1"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on macos: :high_sierra # C++ 17 is required

  fails_with gcc: "5"

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    resource_dir = Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp
    resource_dir.gsub! llvm.prefix.realpath, llvm.opt_prefix
    system "cmake", "-S", ".", "-B", "build", "-DCLANG_RESOURCE_DIR=#{resource_dir}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/ccls -index=#{testpath} 2>&1")

    resource_dir = output.match(/resource-dir=(\S+)/)[1]
    assert_path_exists "#{resource_dir}/include"
  end
end