class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  url "https://ghfast.top/https://github.com/MaskRay/ccls/archive/refs/tags/0.20250815.tar.gz"
  sha256 "179eff95569faca76a1cdbd0d8f773c2cbbafa90e0fcce3d67a8a680066dce7a"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "cedfe8609cd57d53caafa870ced7749a053d17120f8217c674a348024584afa9"
    sha256                               arm64_sequoia: "74dbcee249ebd76e4622ebb433e037d3cadb84c441ca1f4c8933de00faa43051"
    sha256                               arm64_sonoma:  "b498e68e4856fd358cf8c9d3dffcb31f2ff419912e078c39924f284c4e951690"
    sha256                               sonoma:        "85fc2afb1dc84dcffda8178a99831864564dd839cd03874d5d1613c84ff72634"
    sha256                               arm64_linux:   "66532e0dd148b2300b52e6999b7907f59931938b8422703dbef2c52fcc86724f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "001beaf77e3e2f2b127a5755ec07f3076fc7cf89ab8d3f78cd689a2f05fef240"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux?
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