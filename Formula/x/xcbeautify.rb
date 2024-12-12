class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.16.0.tar.gz"
  sha256 "ba42b056d4854672817e88491cc0ae4c7bf950a226ca378a117c5893912e9765"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4a4b786ccf984f2081b57dd5e9480213f1de1756ea738b5dd904e98b23e48cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddeaf37dd320c891945a3b1d78bdf3f6cbffc99c933e0dd52986dc572ffcdfc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fa4b028fa400ead73ea1dc9767b59ec197e858baf65ea13af3b9e57cd6c4069"
    sha256 cellar: :any_skip_relocation, sonoma:        "141a0c53e6dc99a338a73a7574a6da5ba685bf6428f1413ade72bb6099b3464d"
    sha256 cellar: :any_skip_relocation, ventura:       "0271fc715a59fff3da9a36b325c758c57a742b427583c0eb2a92f95402914330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d01b42cc433f052dbf087c681ccd12873d517fdc70ef5c44a7f3197724b0874b"
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