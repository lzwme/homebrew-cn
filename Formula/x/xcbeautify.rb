class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.27.0.tar.gz"
  sha256 "823db0af6ba17a91cc22292add64c7d59472d3377f0229fbc74c92410d616501"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e235aaf88b44d72ccba750507b5d5b88520f91a81a61984281732c3a5ef5088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61b8879076e8ee36a202b0287ed263f3ba6358bfc2aef17dea8e70753dcb9e5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b14e1bf19fa36b2e8736e2a4595e70437f4e70f9b48c9c971471e2fb234a493b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dd3400247db360ebac36409f6a09e6436fb93b9fbae2de747262ed66b2364aa"
    sha256 cellar: :any_skip_relocation, ventura:       "6447da126d44ba319b3e244739c592a956e022adcaf0a1301acb3feafc998a28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fd518a4b86e2e1298e050771aa179220fc594fae29184a58451163360012e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bafc8ac24d2ae349cca4a26d2d05000b2ddcfccfaf38c8763993d9cb72a3745"
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