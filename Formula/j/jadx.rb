class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https:github.comskylotjadx"
  url "https:github.comskylotjadxreleasesdownloadv1.5.2jadx-1.5.2.zip"
  sha256 "5a8b480839c9c61527895d81d5572182279d973abe112047417f237df958a3aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c5c0a76284cf5ec339edfb830b9a57f61f20d588b0c2eed74f95697185c125d"
  end

  head do
    url "https:github.comskylotjadx.git", branch: "master"
    depends_on "gradle" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "gradle", "clean", "dist"
      libexec.install Dir["buildjadx*"]
    else
      libexec.install Dir["*"]
    end
    bin.install libexec"binjadx"
    bin.install libexec"binjadx-gui"
    bin.env_script_all_files libexec"bin", Language::Java.overridable_java_home_env
  end

  test do
    resource "homebrew-test.apk" do
      url "https:raw.githubusercontent.comfacebookredexfa32d542d4074dbd485584413d69ea0c9c3cbc98testinstrredex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    resource("homebrew-test.apk").stage do
      system bin"jadx", "-d", "out", "redex-test.apk"
    end
  end
end