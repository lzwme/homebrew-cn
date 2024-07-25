class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.23.1.tar.gz"
  sha256 "13493fb6603e2ed35b126d4d91f5c747fae1b760e2f4d8c2358bff56ee66fca6"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1215ecf71fd432106ae8f0e2cd226df23961a9fb41436eecddc2c695431a003c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6806fefa7eae99603334650c22785f614aca2f0da22628f93d783d53a4c23683"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "653a4556706937a21fcf041c596b68318b909715cfd1eaacead43523902d45d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "91b0bd65170ff6c6b435cd52edb4837f5eb64fb47681bb5884dda4c962d5fefe"
    sha256 cellar: :any_skip_relocation, ventura:        "fa4f865d1dc71b46fc3b3029c43f49b6f7603c8c2e659b38ff622bd99a66fe52"
    sha256 cellar: :any_skip_relocation, monterey:       "67d31d5ebe0270dd26d77db8ce953fb7846d775fef498b2c7ae011286d017764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22c7a82f67c640db5cac465334bab4ea37473f381d93e1591d7cbad8322b3e01"
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