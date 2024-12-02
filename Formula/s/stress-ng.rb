class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https:wiki.ubuntu.comKernelReferencestress-ng"
  url "https:github.comColinIanKingstress-ngarchiverefstagsV0.18.07.tar.gz"
  sha256 "e2adaab67a70f4f98863d88d92e5805a31adce4559de52419e4f556e2ddeada6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1bb2d0f1412ac75772c1fb514bd12598a7087fa62b227e9215838e9ae7cfb8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3d076e448ef6a613f1d4063ab275692a4fbb60d17a78aa8d5e5ba48aac1da8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b4e6a7556cb463e508698c81727b87cf91f06e9c9e92ad0b8625ef62edbab46"
    sha256 cellar: :any_skip_relocation, sonoma:        "532c934c2c9810bbc593397eb18c0e1cb03089c512f06e23bc33918f783312a8"
    sha256 cellar: :any_skip_relocation, ventura:       "bc49f443452393055698a6062a152966dd4c50c2d88783fe9601d63ed066a63e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaa88250b71a6149e2528980c38af41c47d9b95c994f6d51ed326d548d780a4f"
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