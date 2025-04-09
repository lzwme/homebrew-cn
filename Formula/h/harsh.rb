class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https:github.comwakataraharsh"
  url "https:github.comwakataraharsharchiverefstagsv0.10.18.tar.gz"
  sha256 "351aa79a07d7db0cca2f14b621549bb3a84127f99172395d0926220194a63841"
  license "MIT"
  head "https:github.comwakataraharsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bc28156a4dfce0453b36f2eb556b565b4cbd061dd9d6bada30744ed7b60920f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bc28156a4dfce0453b36f2eb556b565b4cbd061dd9d6bada30744ed7b60920f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bc28156a4dfce0453b36f2eb556b565b4cbd061dd9d6bada30744ed7b60920f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f650845888d5e15af19b1a0d0cd13bcab1713f95ff32e83dd3205bf4cdbbbd9a"
    sha256 cellar: :any_skip_relocation, ventura:       "f650845888d5e15af19b1a0d0cd13bcab1713f95ff32e83dd3205bf4cdbbbd9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dcc658b3b9c8058f5a617801140308d5a2b4c7badaf666c734ce8cb3a58d845"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Harsh version #{version}", shell_output("#{bin}harsh --version")
    assert_match "Welcome to harsh!", shell_output("#{bin}harsh todo")
  end
end