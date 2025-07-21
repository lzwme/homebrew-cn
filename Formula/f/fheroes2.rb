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
    sha256 arm64_sequoia: "9baff8c515153e27ddd79c53d8de8e3210861bd76fc60bd759ea31faaa14be9b"
    sha256 arm64_sonoma:  "5f4ea1d81b9b14583e73b590dfe9a2d438e7a412b3299ccd7e8592c2eae44c86"
    sha256 arm64_ventura: "c02c0b4798619fc514afa126dc6a02c087aecf61704b872549ff6a37efdddeb5"
    sha256 sonoma:        "8316866908ec657a368de88b5a8d590d8ab792a8ef29d529a1e1b4a3f0c3b70c"
    sha256 ventura:       "9eb43a08f27e477aa1877b003c552227a07bf6bc6de499a9de1b1a97bc35c8c5"
    sha256 arm64_linux:   "4da1889d3e7e44ae23f47bbd83daaeead19daa2d246ec770a3990974dc8331cc"
    sha256 x86_64_linux:  "16d973f411077f01a5a78987a51df81117ce5257de7d59b75f4dd23946bc4767"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "innoextract"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  on_macos do
    depends_on "dylibbundler" => :build
  end

  def install
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