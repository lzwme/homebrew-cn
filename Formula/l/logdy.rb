class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https:logdy.dev"
  url "https:github.comlogdyhqlogdy-corearchiverefstagsv0.12.2.tar.gz"
  sha256 "a2fcf5ae44e1e8b43daf96f98a29776b255e8aa8c7caeaca6e5293334b78cda7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba2c86435406e100aa18ee764a608ec88cb8148d28ceb76120107bcc2b459815"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7f72609602006b1ce2466a5160233b9fc34a1157457fc7f17ccc0647c4d2971"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c2227654d22d7aba4f9483e5968c18009e8035f0ea4e579dd971e7fe5643320"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7aba148fcb92c4a53cd98659366f17706f1d260e348b5aa0c88c04fe4d7f2e1"
    sha256 cellar: :any_skip_relocation, ventura:        "f6738c9df22bc14c095d79769b4bac339a2fd9558ec1a062bc8b15517bfdfc45"
    sha256 cellar: :any_skip_relocation, monterey:       "a945764d1c8bfff40455196fbeb5394f1fb2f6a8922fc5b3064680df6c08fca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f0455c5e563ba861484dbb84386417a3d1ed367809690d6c9239742097a17f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    r, _, pid = PTY.spawn("#{bin}logdy --port=#{free_port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end