class Nping < Formula
  desc "Ping Tool in Rust with Real-Time Data and Visualizations"
  homepage "https:github.comhanshuaikangNping"
  url "https:github.comhanshuaikangNpingarchiverefstagsv0.2.4.tar.gz"
  sha256 "0e3d3578a5408ce734a8d62b397e4c7c6621dc599780bbe84f10bfc470da1ae4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a46ba04c938228f178c4b8a00ee5e32e5e2020169da8e972b5c8e1d95a97116b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9974fbfb15d16262440d6f07e1d15c0bc2862ef1649b96bdfbf71dc134a85f28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8f695caf74091167b42a8abe1ae37be5fcccd479c3b3d05f1e345c3a072afc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "53855e201900f93d2db5d5f05aa597813f2737f3209ad1220b286dd0d7994874"
    sha256 cellar: :any_skip_relocation, ventura:       "52582a4b3079e12636af8994a7b493b15d0ab97937e8640601e99c022447113d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8a3039be6dd0c33c00dcd3161debea75ce352302c29b33f22c7f94ffc0143e8"
  end

  depends_on "rust" => :build

  conflicts_with "nmap", because: "both install `nping` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "nping v#{version}", shell_output("#{bin}nping --version")

    # Fails in Linux CI with "No such device or address (os error 2)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin"nping", "--count", "2", "brew.sh"
  end
end