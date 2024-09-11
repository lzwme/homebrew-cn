class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https:wiki.ubuntu.comKernelReferencestress-ng"
  url "https:github.comColinIanKingstress-ngarchiverefstagsV0.18.04.tar.gz"
  sha256 "c76cf067e582fb8a066d47207bbccc6d0d4175ba700b5d122909132d79e7f6ea"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f05ee7fd31d3a35b356f0d65757d1d1e7a9501552da05d47df5e6bfdd214406b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0646a3bd5de2a42279774f18ddc66fc368191fc4455eb7642fcfab3c41de28ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fb9c4b7f7f6039fdd9b4ae26615bc0305034b3a842d97b9e466971203aae7fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54fad38559f57aa0df41f9af48855020144a669b465d5ae0c7663c5a493f71a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "76939d4579c152ddc6cb890838bd7600391d320cdfd7801c54c6e802749751b9"
    sha256 cellar: :any_skip_relocation, ventura:        "045adfa2f4ce14fe78645cd895e930ef04a079c29732e0530357a662e2a4eb84"
    sha256 cellar: :any_skip_relocation, monterey:       "c5d86746f5cc32f04b1413641b449739b45c4b46b3241453cddb791963ab2b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "192ac5825fb2cd8bddb5afceb428626ba1bb0bc2e1acb04bd03c02ca2a02f5b3"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "usr", prefix
      s.change_make_var! "BASHDIR", prefix"etcbash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completionstress-ng"
  end

  test do
    output = shell_output("#{bin}stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end