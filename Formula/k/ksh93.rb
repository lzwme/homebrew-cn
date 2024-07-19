class Ksh93 < Formula
  desc "KornShell, ksh93"
  homepage "https:github.comksh93ksh"
  url "https:github.comksh93ksharchiverefstagsv1.0.9.tar.gz"
  sha256 "c58d618b551c594580541a0759e32ea6ddadd7b7a84f9f3ebea2ffb9a5d9d580"
  license "EPL-2.0"
  head "https:github.comksh93ksh.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b2746bb53c6263126f54469e74088054c2b48bb38a960e2a5aa7ce3ee4685469"
    sha256 cellar: :any,                 arm64_ventura:  "6d95995b7eb5daf05c38f633cbeb9e4be2c0a75eaa25b264f9373c6a8ff59d1b"
    sha256 cellar: :any,                 arm64_monterey: "40b15c75e35fd8148a9808e756c70c6e5fbf530e5ef88d6e8c2728454d88facf"
    sha256                               sonoma:         "cec9285ad645b16acf320a94f7cd4d167e67ce5a3d1459d4d72b72c75f1aff1d"
    sha256                               ventura:        "c5350c423d8b7b6f483d7e6322ff9a50d5002aed286549e1dc5f2d07513388c7"
    sha256                               monterey:       "ed70b7a230a7a64259bea12eeadb787e14311b48679694fb75a50c1e9a4fc8e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d244513bfb52e3d6e589db05f56fe6009b8de018cf02f0313dd2d10398eb80fe"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}"
    system "binpackage", "verbose", "make"
    system "binpackage", "verbose", "install", prefix
    %w[ksh93 rksh rksh93].each do |alt|
      bin.install_symlink "ksh" => alt
      man1.install_symlink "ksh.1" => "#{alt}.1"
    end
    doc.install "ANNOUNCE"
    doc.install %w[COMPATIBILITY README RELEASE TYPES].map { |f| "srccmdksh93#{f}" }
  end

  test do
    system "#{bin}ksh93 -c 'A=$(((1.3)+(2.3)));test $A -eq 1'"
  end
end