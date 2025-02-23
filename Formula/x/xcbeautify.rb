class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.26.0.tar.gz"
  sha256 "dde05d2d0af03b278b54ff706c952172b8898b22263de457e8866a672c166dd5"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1819cf6e95a29bec69dd649106f1d42ae5838729b98a669a1f0c631969663dea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b329c43a8053b901d3adaa02e6767a834db105e21aa88147de654ac397b6fca5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34b9d1fc3c93fbc82ac7d1905c8be4d45263ca96b01020c27bc0bdf327a85001"
    sha256 cellar: :any_skip_relocation, sonoma:        "2df3a49f5000fb5c3eb0fad3115c3c8d18a5b7ada12d5975256f27da1cb0046e"
    sha256 cellar: :any_skip_relocation, ventura:       "e72146bd59383b3da11811d7330f84dec0d49c26d20e6d2fac9f531f46a5762a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82b2d7234b2abb1dd840322a498517e069e8708cc12dc5f7e0009e4c78ecfeee"
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