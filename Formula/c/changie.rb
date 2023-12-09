class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://ghproxy.com/https://github.com/miniscruff/changie/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "e30a1eff339669763ec217ad29ba20352cd64765cc9e6f09b190436eb7fd6be7"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da78f706fbf22d9c1abdbb3b75f7aacdc982b8d25bb8ab3f4a2afe37e0574509"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "546b4f2845aeaaf16a3f4a7f2d65c4a636eb29528dd2b4027e9691eede2661fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19c15e552604a24fc38c1a72b759f0732e7e23d4b2e20c2188e8cf045539ba09"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7183befe183dbc1b5ab8d8a624461877a560cd166cfeee114fc33b701dafb61"
    sha256 cellar: :any_skip_relocation, ventura:        "b4bbe3f0bce3360cc54e9936a5ef28a803303502adcc83bc45be56e374d2d6c7"
    sha256 cellar: :any_skip_relocation, monterey:       "1cbfbac5ef44566edf46282715fbb403e61441d4bfcff0bd74d816325750f019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01f761c122f9b2f0f89a0ebb39df02ef549d285758f5282cf300afac90fc5c07"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"changie", "completion")
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end