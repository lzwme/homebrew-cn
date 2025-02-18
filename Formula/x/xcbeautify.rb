class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.25.1.tar.gz"
  sha256 "c7a9d999dfa27184601b6df817a5bfc9acaa0b0b7b93886126ff281862548efb"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9f1f6272f989d602cf204d22eaec27061369ea82f5d87f3f3d4131b79196f58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8169cce9d95da1365ff333852e650ccde8a3d000daf989e6a3eb87a5995aefb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bee80d45910710a373e5bbef995898bf76585f90813301bd9fe7613ae41ec0fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b1af2e3a8262542e960e8bb7ad7b0674e84ba88d76329e70562bca5cc6b4a1e"
    sha256 cellar: :any_skip_relocation, ventura:       "2af407c945b385dac378987ac5404523b94520a361cbebf3e88a42eafd51e4ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac133ca611594a8cd87f90962f5a802435c79e7d051f246c24296b9bba991b5a"
  end

  # needs Swift tools version 5.9.0
  depends_on xcode: ["15.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".buildreleasexcbeautify"
  end

  test do
    log = "CompileStoryboard UsersadminMyAppMyAppMain.storyboard (in target: MyApp)"
    assert_match "[MyApp] Compiling Main.storyboard",
      pipe_output("#{bin}xcbeautify --disable-colored-output", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}xcbeautify --version").chomp
  end
end