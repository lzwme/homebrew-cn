class Ijq < Formula
  desc "Interactive jq"
  homepage "https://sr.ht/~gpanders/ijq/"
  url "https://git.sr.ht/~gpanders/ijq",
      tag:      "v1.1.1",
      revision: "5f067d848a2d3aa9e0e7b338e9062fa1f0819823"
  license "GPL-3.0-or-later"
  head "https://git.sr.ht/~gpanders/ijq", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3936978096c0945f4e3f050b2e383b0b4070707091dcacc48710cacf5ebdcd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c27b6432f070866f7c967ddf7b654351a3af80ce41b300166d28cfea6e3f26a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30024923a0708555578eed1b11aeea454dcbc477073cbf5376d6d14bddb9cebe"
    sha256 cellar: :any_skip_relocation, sonoma:         "c13ce5bfd91dcc905a104ab71a4c2bcdd473602e0b8e3db7893ba3acfebe1420"
    sha256 cellar: :any_skip_relocation, ventura:        "d85b47a5205a245387f827a8c6854a7c6207ced184d18c060a86e134ab429458"
    sha256 cellar: :any_skip_relocation, monterey:       "ea817020bc5cf03a72eb1feab2abc58805d63e93c18eb0418a02267b53f4133e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4dea9ad4ed97d19d1a8e44da7a035ff3bb83254ac6a8e5d598653df269d66f3"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build
  depends_on "jq"

  uses_from_macos "expect" => :test

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    ENV["TERM"] = "xterm"

    (testpath/"filterfile.jq").write '["foo", "bar", "baz"] | sort | add'

    (testpath/"ijq.exp").write <<~EOS
      #!/usr/bin/expect -f
      proc succeed {} {
        puts success
        exit 0
      }
      proc fail {} {
        puts failure
        exit 1
      }
      set timeout 5
      spawn ijq -H '' -M -n -f filterfile.jq
      expect {
        barbazfoo   succeed
        timeout     fail
      }
    EOS
    system "expect", "-f", "ijq.exp"
  end
end