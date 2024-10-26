class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.14.1.tar.gz"
  sha256 "ecd8843e7beafceafd4c4dd333532dcb835cd7a85de6df2b1bf2015143838cda"
  license "MIT"
  revision 1
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "477190763c3a3e09eb884c9cb03c5d70840a8ee83df251ac28f8f98f8ce9e9c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0502dab9300dad524076f18909dd85647be5ed760938978f8c79d63707b3774"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81def6d63583a62be784b4a70a1f31d9169caa0f2ae304b91c484ed5929549ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "493db4880aaa4bcc6d56ef1fb4fba51f677b5d9f4404e79a1d60d2c8712d0972"
    sha256 cellar: :any_skip_relocation, ventura:       "3f3d5fa32131a27417c862af19f50a841198a330860961f3a065e35bf3782ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20f0b45bcfe4d4b4420a986f5e28ac7d3285f25854ff3be924dd49e30950cbe5"
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