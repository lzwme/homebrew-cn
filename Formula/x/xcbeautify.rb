class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.24.0.tar.gz"
  sha256 "26d1647880e50ca4e88197d909fc27d8b5be94036aa645704b6a3e1c526e6fc6"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b521f98d09fbe209b16dbd6530cf3a50675247a4db017bba680e05b750ccc9f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53d4adc097a2728f340440bf40b954dcce2817e637b4d31845fce1a87ed23c01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e25bd5036f8a72fd9b826b0b45e79e247d36f002754eebc19acf9429223032e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "be12c5e2289af28778283eaf5264a4e15c16bbbdf733f86f1921438e9d00c34c"
    sha256 cellar: :any_skip_relocation, ventura:       "d19f03c186500505c3c422ec6347af22df037bcd694de1b383cad9202ef842fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82c5d196c15f017e24aa09f80d01f21a5c1d3d4e0cff59d3ff0c5a8f72e9601c"
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