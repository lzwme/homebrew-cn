class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https:github.commfontaninipresenterm"
  url "https:github.commfontaninipresentermarchiverefstagsv0.11.0.tar.gz"
  sha256 "5bd6171bcc1375741d6a710df29b33b11fed12104daecec714462f5244c5cbf6"
  license "BSD-2-Clause"
  head "https:github.commfontaninipresenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e81571ef4aecc6dd53a3cb2ed21e2555fbac8d2421519016ecdc2a06324138b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5763e499e01a6390ddafd342c819e348b3f58ad9825fc6e29ad71be8d3561c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "779938a29879ca82a981f36c5161e2923be84dab909a9d392276362d49a59e9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2a04d6adb4ac2ddde9ea192df422c6563a2bff04edc8c10003110bd5aacd040"
    sha256 cellar: :any_skip_relocation, ventura:       "d10d4c77d44be756ead83bfc61baeae0ec5cbd8d13f1b6c17bb96295fae57b51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ed3d2a6eccce2a21d01e8a6219c54d08be69f26d0cdf5210e68f027ae2a7184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e106cc742995203fb7ca9de0713c8c6c0f3e1a18ea5da7e0d99bf3104353080"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}presenterm --version")
  end
end