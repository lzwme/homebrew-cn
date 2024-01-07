class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https:murex.rocks"
  url "https:github.comlmorgmurexarchiverefstagsv5.3.7000.tar.gz"
  sha256 "1fce60ae88819fbf74e12c8b92d0d5489c75cec598ed04821d913c7acac9ed25"
  license "GPL-2.0-only"
  head "https:github.comlmorgmurex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8366cab22c960de13e60c3fbb0f1429c7c7e43b6bcbff689d3e717e43c62294"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0865ed7c32e865e1fb1c9cb77723f772e47816dd11eb68a486f717f57816df8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63850d6b052e7dc2d7080ac3d789029a07c4cd75fdcf15c37634d5e5c08a5ef4"
    sha256 cellar: :any_skip_relocation, sonoma:         "08e9dfe4f9636cec37a9af858a350976493e6ef4d4742a4ba031ec29efc6318f"
    sha256 cellar: :any_skip_relocation, ventura:        "90ed7b2afcc091f9bf32e0451c194aa0f91ff7fed1edf8384b6efc239a99bcc9"
    sha256 cellar: :any_skip_relocation, monterey:       "62310373a057b9717ebe6c5068958d0c7c6788644ae73fe3bc2b6d8e540fb106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dc5f7624706f3432173c9d5eb9fb1fd5fd18937190305b3dc5c36599ef74806"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}murex -version")
  end
end