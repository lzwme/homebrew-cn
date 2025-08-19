class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://ghfast.top/https://github.com/ihhub/fheroes2/archive/refs/tags/1.1.10.tar.gz"
  sha256 "c44e25e1b3874718382bb9b545d5181b56cbd01cf773337851111a03bb8577af"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "851e74e6658e0b8106765c9992a5d30df0d56073589b5562c45361fbf09413d2"
    sha256 cellar: :any, arm64_sonoma:  "a1cf0ac6be190408b51876c9ae93f4f22ecef0269e1bc8c26c04f6978b3b1070"
    sha256 cellar: :any, arm64_ventura: "fff2f833461cd07ab2438c5b32dd6f6ac71d3334c58d017b1f86d68b447f558a"
    sha256 cellar: :any, sonoma:        "9500f49a79a5b401d008b4a6951a0ebfd2ea39b2d1b137bc0ede1731ee4d7bfe"
    sha256 cellar: :any, ventura:       "c89828194a38cb4f8353c70e98fee5b1d2e596d270e7b04d34faf842f46a3b46"
    sha256               arm64_linux:   "9597b31091971e38251f3d8f4904f4d996648235b7dd7cd0881aed6750f2c1b2"
    sha256               x86_64_linux:  "ef0f9d5f228ce4a4b9feb2a13e988fa35efefc93203c1c4426dddd0a8adf04eb"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "innoextract"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  def install
    # Avoid running dylibbundler to prevent copying dylibs
    inreplace "CMakeLists.txt", /^(\s*run_dylibbundler)\s+ALL$/, "\\1"

    args = std_cmake_args
    args << "-DMACOS_APP_BUNDLE=ON" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install "build/fheroes2.app"
      bin.write_exec_script "#{prefix}/fheroes2.app/Contents/MacOS/fheroes2"

      libexec.install "script/demo/download_demo_version.sh"
      libexec.install "script/demo/download_demo_version_for_app_bundle.sh"
      libexec.install "script/homm2/extract_homm2_resources.sh"
      libexec.install "script/homm2/extract_homm2_resources_for_app_bundle.sh"
      chmod "+x", Dir["#{libexec}/*"]
      bin.write_exec_script libexec/"download_demo_version_for_app_bundle.sh"
      bin.write_exec_script libexec/"extract_homm2_resources_for_app_bundle.sh"
      mv bin/"download_demo_version_for_app_bundle.sh", bin/"fheroes2-install-demo"
      mv bin/"extract_homm2_resources_for_app_bundle.sh", bin/"fheroes2-extract-resources"
    else
      bin.install "script/demo/download_demo_version.sh" => "fheroes2-install-demo"
      bin.install "script/homm2/extract_homm2_resources.sh" => "fheroes2-extract-resources"
    end
  end

  def caveats
    <<~EOS
      Run fheroes2-install-demo command to download and install all the necessary
      files from the demo version of the original Heroes of Might and Magic II game.

      Run fheroes2-extract-resources command to extract all the necessary resource
      files from a legally purchased copy of the original game.

      Documentation is available at:
      #{share}/doc/fheroes2/README.txt
    EOS
  end

  test do
    assert_path_exists bin/"fheroes2"
    assert_predicate bin/"fheroes2", :executable?
    if OS.mac?
      begin
        pid = spawn(bin/"fheroes2")
        sleep 2
      ensure
        Process.kill("SIGINT", pid)
        Process.wait(pid)
      end
    else
      io = IO.popen("#{bin}/fheroes2 2>&1")
      io.any? do |line|
        line.include?("fheroes2 engine, version:")
      end
    end
  end
end