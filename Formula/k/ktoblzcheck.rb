class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.58.tar.gz"
  sha256 "f598678afa22bf06d8952d31bc7f66faed253e3fa3cf87f4a948ade0bcdb91cd"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ktoblzcheck[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "1adf317d22159def7835fc740182d7764822c13461fe9d0975034c6f74cf9034"
    sha256 arm64_sonoma:  "be5101feb8419e3e745433284c8e6c954b29780acd7c984a60b48aedb12d9c0c"
    sha256 arm64_ventura: "0781aa09d4b9d8bed14577d2c001d93bb40359828f0f56ffa0e88da9abbc2136"
    sha256 sonoma:        "cb1e09fa11aa4948d5286666f7eaf81fa320dd18d2d42acea0e6aaf089f2b9ef"
    sha256 ventura:       "a8f697bf6ff7baa266c19b67cb96ea1a72e019a56b68f9130737519d4f7528d7"
    sha256 arm64_linux:   "21fb1fd39b7045eede6d698615f0e528c249fb61605f365e161980e9e1dd1b9a"
    sha256 x86_64_linux:  "5ff9f34b3a9dd547c98ca7779337357978b54988b2af7b7a40a219881b3d084e"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13"
  depends_on "sqlite"

  uses_from_macos "curl"

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/d3/38/af70d7ab1ae9d4da450eeec1fa3918940a5fafb9055e934af8d6eb0c2313/et_xmlfile-2.0.0.tar.gz"
    sha256 "dab3f4764309081ce75662649be815c4c9081e88f0837825f90fd28317d4da54"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/3d/f9/88d94a75de065ea32619465d2f77b29a0469500e99012523b91cc4141cd1/openpyxl-3.1.5.tar.gz"
    sha256 "cf0e3cf56142039133628b5acffe8ef0c12bc902d2aadd3e0fe5878dc08d1050"
  end

  def python3
    "python3.13"
  end

  def install
    ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)
    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath, build_isolation: true), "."
      end
    end

    # Work around to help Python bindings find shared library on macOS.
    # OSError: dlopen(ktoblzcheck, 0x0006): tried: 'ktoblzcheck' (no such file), ...
    # OSError: dlopen(libktoblzcheck.so.1, 0x0006): tried: 'libktoblzcheck.so.1' (no such file), ...
    inreplace "src/python/ktoblzcheck.py", /'libktoblzcheck\.so\.(\d+)'/, "'libktoblzcheck.\\1.dylib'" if OS.mac?

    # Fix to changed filename for `NL_BANK_WEBSITE_URL`
    inreplace "CMakeLists.txt", "BIC-lijst-NL.xlsx", "BIC-lijst-NL-2.xlsx"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{opt_lib}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Ok", shell_output("#{bin}/ktoblzcheck --outformat=oneline 10000000 123456789")
    assert_match "unknown", shell_output("#{bin}/ktoblzcheck --outformat=oneline 12345678 100000000", 3)
    system python3, "-c", "import ktoblzcheck"
  end
end