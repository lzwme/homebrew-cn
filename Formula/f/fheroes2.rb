class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https:ihhub.github.iofheroes2"
  url "https:github.comihhubfheroes2archiverefstags1.1.7.tar.gz"
  sha256 "6419ad0bd0f1f684a9256c39fb6c02a026fc76581b0bc9632a597fbc8443fc03"
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.comihhubfheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "bc01ee94d9ecd36f09f149366c23f85cd0f363ff70057be2752c5d84cd1c20ec"
    sha256 arm64_sonoma:  "9bfa43f76dbdf75d4080a2b485958dea69aa7229e54f6994d91f21c522d81d91"
    sha256 arm64_ventura: "8f5cf53765b7c2557a4878a8584cbf3f680a1796f03198dd71a74aa4054f8ab7"
    sha256 sonoma:        "2d3c25d9088d2bcdb9b14798fd1ba229df52397278a6808f418810da98899cc8"
    sha256 ventura:       "f24d762fb936c938b25b94bfbf9df00f98aadad30ef1cdc5b97f76bc7459b7b4"
    sha256 arm64_linux:   "b24eec3d0dde1f216b7d13770a45a25af180c8e9c0de76ed846bd7645ae224e3"
    sha256 x86_64_linux:  "cad5dfc921539d0252a5b4ebf44678ca7a194aafcde720bec8259773f9497fd2"
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
      prefix.install "buildfheroes2.app"
      bin.write_exec_script "#{prefix}fheroes2.appContentsMacOSfheroes2"

      libexec.install "scriptdemodownload_demo_version.sh"
      libexec.install "scriptdemodownload_demo_version_for_app_bundle.sh"
      libexec.install "scripthomm2extract_homm2_resources.sh"
      libexec.install "scripthomm2extract_homm2_resources_for_app_bundle.sh"
      chmod "+x", Dir["#{libexec}*"]
      bin.write_exec_script libexec"download_demo_version_for_app_bundle.sh"
      bin.write_exec_script libexec"extract_homm2_resources_for_app_bundle.sh"
      mv bin"download_demo_version_for_app_bundle.sh", bin"fheroes2-install-demo"
      mv bin"extract_homm2_resources_for_app_bundle.sh", bin"fheroes2-extract-resources"
    else
      bin.install "scriptdemodownload_demo_version.sh" => "fheroes2-install-demo"
      bin.install "scripthomm2extract_homm2_resources.sh" => "fheroes2-extract-resources"
    end
  end

  def caveats
    <<~EOS
      Run fheroes2-install-demo command to download and install all the necessary
      files from the demo version of the original Heroes of Might and Magic II game.

      Run fheroes2-extract-resources command to extract all the necessary resource
      files from a legally purchased copy of the original game.

      Documentation is available at:
      #{share}docfheroes2README.txt
    EOS
  end

  test do
    assert_path_exists bin"fheroes2"
    assert_predicate bin"fheroes2", :executable?
    if OS.mac?
      begin
        pid = spawn(bin"fheroes2")
        sleep 2
      ensure
        Process.kill("SIGINT", pid)
        Process.wait(pid)
      end
    else
      io = IO.popen("#{bin}fheroes2 2>&1")
      io.any? do |line|
        line.include?("fheroes2 engine, version:")
      end
    end
  end
end