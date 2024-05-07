class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.19.2.tar.gz"
  sha256 "e7d6f44410bc6cca77ee37afb00ad97c5e83018a62a9d6483ef3999b1f5d8799"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb7beac489534420c2f5c6ec2349c9e3b8226b69bbc4484f4ea52f2e20519153"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dce7148ddf6359e577e401a7ced935b2d8dbb29988582216e3d0ccfa5d03a1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b951602ad84023d0a78e3cf44521534479042b205f0f3c12445cdce6885aa071"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6592e6f99ff177baf5e004e4c48385992fed63ec778121d46e44d2927484ae8"
    sha256 cellar: :any_skip_relocation, ventura:        "eb712e3dd892432c4faedc94cd2bb94474281fa6e0232b240ba8124b6a9c72c3"
    sha256 cellar: :any_skip_relocation, monterey:       "f3c01ef79ae3af6f224df3b4c3a731e4d7c98a5ca20e4074600cf49e677aa446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5c97ddba4f536b160cf461cff1824eda837eda0df8cbb4e901fe0d03040a898"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gitu --version")

    output = shell_output(bin"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end