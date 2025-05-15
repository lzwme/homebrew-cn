class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.com"
  url "https:github.comrailwayappcliarchiverefstagsv4.5.1.tar.gz"
  sha256 "65e77d90cb3d642e04a92403bcdfeb0e7417661f01d37c67ff11805f8e798dca"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa3ccabfd1518686094d557340c458a574e5aabe7b86503d83a897c99984a13b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17755ec6b55e14f157678065460e1776afbe27222ef22bfce14091afd52dd6b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d617a420c066c05d1025e4f57a064b6701a56b994231c3d0db26a03e65af28d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a99d7b4bc8e0a99a5a6ea1ba4967c00c8955755a6cb231c4be43bdc6b69c6a5"
    sha256 cellar: :any_skip_relocation, ventura:       "0361a2171f7c2150b003e8c422ab140542f0acfea26545df7bcafe5394fefa42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "911d8aaa4558fdf68c4363992b2ffcaf2d087f04791dc15f4227adc318517222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "937d91dc990eb698d057a62ab8e35c349c4c3340d2b650b8344965a88efc1c15"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}railway --version").strip
  end
end