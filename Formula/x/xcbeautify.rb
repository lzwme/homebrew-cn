class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.2.0.tar.gz"
  sha256 "df73573b0db4bb9795962ebc0fb952d97ad027fcd5b5e5a95b77e9204beff2f4"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b834e92a7ca6448bb2ac8d264c4a65d2732533fd7cff757a41115926a829d9a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "947269c1af6dcbaa5f720ace3101247f009f4dac5f5b7ee8c74b4ec81fa6d43a"
    sha256 cellar: :any_skip_relocation, sonoma:        "004cf3bf5dcc1a0fe2d8b4552f65a2766b1f14d0193a6c3db0f09707f8924d5e"
    sha256 cellar: :any_skip_relocation, ventura:       "5b52c20c7219e2a0dc5b3df502bdbe8c4b17c7069c64751fdb80e20a7802d466"
    sha256                               x86_64_linux:  "4bbe752c37a455418b7709e8a7084cad73490eb42b9773a31f530a92fa0fd944"
  end

  # needs Swift tools version 5.9.0
  depends_on xcode: ["15.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
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