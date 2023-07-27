class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghproxy.com/https://github.com/gleam-lang/gleam/archive/v0.30.4.tar.gz"
  sha256 "8c2d8155e4f4cf4d3ca3e85892b6e5bed0930c491a1384b1018a39afec7949e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1927fd55091f5fca5b4a11cd1cf558c21d057509b25d312ab04676a9403d2b27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff4cede4df7c41143a77f2d37a8df992c7c26430d9b4dc7a66d1b2d3403b86a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c0c5da0309f2b0248da149b928e60e2878896dca532ccdadffab864a0f80644"
    sha256 cellar: :any_skip_relocation, ventura:        "34957daab322030948dfcd8a9d3d552025e2043cd09ca47f794ab2f7c37c12b9"
    sha256 cellar: :any_skip_relocation, monterey:       "de0b0c018dc9c02420513d8f444ea19616903ca3f1469b072e2a68cb7276faee"
    sha256 cellar: :any_skip_relocation, big_sur:        "51a3d78b082e499592ca8254a3a2bba9e51f6e3a1f2d9d479641102e52f32950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13fa5ea7cbdad829a2f0be6c8467ebd61448352f6216c18068f7d88a985f9a3e"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end