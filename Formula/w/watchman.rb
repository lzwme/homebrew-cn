class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghfast.top/https://github.com/facebook/watchman/archive/refs/tags/v2026.05.18.00.tar.gz"
  sha256 "de2080ec764a1f3b58655a49395a8a53ccbe19397e9e2e8c75d01b3b49e3730d"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bcf86259dc02c1822f9e34dcbc69ab573d5429f0f0e3e72acf1099c9164760bf"
    sha256 cellar: :any,                 arm64_sequoia: "33a578994f8e4dc0f11908ecd8f1bc2e4a584a532ee7fad354820f2abea92f9d"
    sha256 cellar: :any,                 arm64_sonoma:  "f1bf584baebb1afad892c13eb1f8a3d61375ee36b20b3416cca19a96ffc466d2"
    sha256 cellar: :any,                 sonoma:        "1d8d8ed128f9c7cbece6e0fb204bb06a2c113710967e887be28685507203a9fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0e8629bf41aaac15b832cc7909ff1c3686bd4fe1d7d4eadb109df23801a7af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94e54d2f473cc9407a14defa76f0b838341b21dcc5589f831da9014d38cbd989"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "gflags" => :build
  depends_on "googletest" => :build
  depends_on "libevent" => :build
  depends_on "mvfst" => :build
  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "glog"
  depends_on "pcre2"
  depends_on "python@3.14"

  on_linux do
    depends_on "boost"
    depends_on "libunwind"
    depends_on "openssl@4"
  end

  def install
    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.14")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_USE_XDG_STATE_HOME=ON
      -DCMAKE_CXX_STANDARD=20
    ]
    # Avoid overlinking with libsodium and mvfst
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    rm_r(path)

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end