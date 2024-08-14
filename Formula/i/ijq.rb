class Ijq < Formula
  desc "Interactive jq"
  homepage "https://sr.ht/~gpanders/ijq/"
  url "https://git.sr.ht/~gpanders/ijq",
      tag:      "v1.1.2",
      revision: "f67100db8b03095fbd25fef8c7f01e6407023923"
  license "GPL-3.0-or-later"
  head "https://git.sr.ht/~gpanders/ijq", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a744ffeab4e167df5562e00df9f6881619690890b944e8812c36f6bf173c7b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd09def3304b0cfcd714745a057853784b49e482a32d599db45c742d2eac3522"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "539054df9a9d84798427580397d6495c34f7ce8fd844fa8073fa7eef765727c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1821ef799142750e30c540f77a45b584c376d7806638fb9deddda3aead6c1c6"
    sha256 cellar: :any_skip_relocation, ventura:        "593ef098186825e2813b8d33687f3d7781e48d765a51f3d7e7801441579394b8"
    sha256 cellar: :any_skip_relocation, monterey:       "f9343078267b776e7fe34ab333b29753cfc44aec8ab291507b43cb7a815faa0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92b37ce9a8a054ad37bfefe48a1d1b03ed163527545ba10de7b7f0c3c3a9825"
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