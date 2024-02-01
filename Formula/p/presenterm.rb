class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https:github.commfontaninipresenterm"
  url "https:github.commfontaninipresentermarchiverefstagsv0.5.0.tar.gz"
  sha256 "88ec6673bbe44146b7dee072020c40061732569a3fef60a3538d3bb1756f076d"
  license "BSD-2-Clause"
  head "https:github.commfontaninipresenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61eda55c1fea0771bdce17bdce156d7176844bb24f999086d533689d228a4fdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3a47bd664cdcc48d25865428a9d87dfcca9d7e7e20011941c9b30b54f034bbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a8ad59cc08c4c9588f2ea7c3c88eaa4ab09233aef47c8f1d83a84ca28dd80db"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bfc178b3c0f397c93bba1c750ca5fedce22dfc7310c9792ae8ba2a86f70f8cb"
    sha256 cellar: :any_skip_relocation, ventura:        "dc7e1f734ae67ef0cc31c31b875452cfb45ad27bf5842301834ba2499d68da2f"
    sha256 cellar: :any_skip_relocation, monterey:       "a464a93aa24c11bf195e128a3babe7048a9d3e0ff0504228678a0a7bb18ac01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "256cf7d74edcd90a1e7c6f775bf625461484ffc479a6677a79572ea01fc3be35"
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