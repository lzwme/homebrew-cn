class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https:github.comMHNightCatsuperfile"
  url "https:github.comMHNightCatsuperfilearchiverefstagsv1.1.0.tar.gz"
  sha256 "703ab37f1bb994e7decc0b48200dd82b24e58ddff8d3204d9cb53fed67ef0f4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aade6bf4c32afcd3dbcacb7074a9c7aaca440af4dd3070f637e054d26f5a6f57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4785703d03ccc8f72c4dec7fc280e2dc802eb499c7a4a16833188a056f70730b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3ee5013dd6dff8bb1b4399ed3696426ec9e904f271505dd5c2e46c213f8a396"
    sha256 cellar: :any_skip_relocation, sonoma:         "53cac3ca7432e25137407245859af13e3a84e8b05992e0516cc81a52dd72c43b"
    sha256 cellar: :any_skip_relocation, ventura:        "4cf0369b7027e5b739ce6d82da46c484c034b1d51d62aa140e64296f20090a26"
    sha256 cellar: :any_skip_relocation, monterey:       "f7dbe2d8a182c04c57de03cd6d83843ce4182d4ab4613f33279c2b912bdfac3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a5f1f74449b463da5965a28a460ef4e7aa8d68cebc169c4e0abf7921ececa41"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"spf")
    end
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}spf -v")
  end
end