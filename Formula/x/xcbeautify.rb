class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.9.0.tar.gz"
  sha256 "b19d7372e63a13de6f86cb1ef60f67ed7f51a0b82adb2a508144d4c0d8420dd7"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67b5f07ed519407c4152fabd31ea75a994265ebb5f2d03d28b2df2925a7579bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "867f0a344fa5277008f6f550e6c1855caf3306b1dfb80ecf60d94a361e9aa70c"
    sha256 cellar: :any_skip_relocation, sonoma:        "93502111d61f09071d4e3a0a0f3d315870fb38add3e987450454df2133ea50ad"
    sha256 cellar: :any_skip_relocation, ventura:       "c599a6b24f65c607b63d670458230f5ad47f35bddd0c6f9b8b47c364b4d6505c"
    sha256                               x86_64_linux:  "6cfcce013c86607c83dcf8881472026e0036478dbeeb529213210c7cf88ecd6c"
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