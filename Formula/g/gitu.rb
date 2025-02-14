class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.28.1.tar.gz"
  sha256 "b84571bce08f2af6aee91ef9e6ebd8b41469ed43f956a3223daa7e53ec7371dc"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35442e59f8843d4c7a467e9167bcaafe66d0f8335087fb89e189e01ed7061ca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0da0eba3134f9b7c5ee79296416938bb317245478d569515c062945e91b380c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53f72762177b1f64fa1f99b1e7975916db94c3ac8859a374d5925d7df7382b19"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ec03a97f248ed4e4ba38f9a2e194829989eae27b3e2215f21c4ab8bc1799369"
    sha256 cellar: :any_skip_relocation, ventura:       "8975563169f41d8a4087371cd8a034ebafce0840b3b01b1ecad52be35c89dc93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfa9ad63bb4bc50c36ec712ffb61d591576b09a31d8f2f669b10ef236565c393"
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
      assert_match "No .git found in the current directory", output
    end
  end
end