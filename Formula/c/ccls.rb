class Ccls < Formula
  desc "CC++ObjC language server"
  homepage "https:github.comMaskRayccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https:github.comHomebrewhomebrew-corepull106939
  #       https:github.comMaskRaycclsissues786
  #       https:github.comMaskRaycclsissues895
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https:github.comMaskRaycclsarchiverefstags0.20240202.tar.gz"
  sha256 "355ff7f5eb5f24d278dda05cccd9157e89583272d0559d6b382630171f142d86"
  license "Apache-2.0"
  revision 2
  head "https:github.comMaskRayccls.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "456e64f301999bde6fd6fbb722c567394889be93b89488052936f14e35f96a92"
    sha256                               arm64_sonoma:  "62c9aa4d98c0d97dadcbde5f70d5b47725d1dc360fd2f017472baae37336fad1"
    sha256                               arm64_ventura: "9e105743aa472cc07f74892abe7b3a1bce9c9c0b6ab53405dfdee0548b04ef01"
    sha256                               sonoma:        "e1e19b603b8825c9d9552a75e23a8436066b0cc7fbc22ec155c467a3e8c619cb"
    sha256                               ventura:       "2582130416de11b29dd35833f983f2f865fea39e52f3e046b86c822f5bd47444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "057d51586172d98b836683ed9e2ba3fc12abdde0b3de8451c60b73f543792cdb"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm@18"
  depends_on macos: :high_sierra # C++ 17 is required

  fails_with gcc: "5"

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux?
    resource_dir = Utils.safe_popen_read(llvm.opt_bin"clang", "-print-resource-dir").chomp
    resource_dir.gsub! llvm.prefix.realpath, llvm.opt_prefix
    system "cmake", "-S", ".", "-B", "build", "-DCLANG_RESOURCE_DIR=#{resource_dir}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}ccls -index=#{testpath} 2>&1")

    resource_dir = output.match(resource-dir=(\S+))[1]
    assert_path_exists "#{resource_dir}include"
  end
end