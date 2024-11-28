class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.82/putty-0.82.tar.gz"
  sha256 "195621638bb6b33784b4e96cdc296f332991b5244968dc623521c3703097b5d9"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f09d7bfe2bfd74570c0bd49b31b4f9001715c6cf092076df643835573be8ac55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8532e4f40cd79e4c86904d1b55523c162154c59310a9fb708ee191cc7d0d4a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4a58c9affe4cfee0189680417c6a67681536cc7d4cc84a192320afb2b80aa76"
    sha256 cellar: :any_skip_relocation, sonoma:        "85528e9395420ae3468bb87b6d02746f194fe62f30119a159b2b84ae9fe0d268"
    sha256 cellar: :any_skip_relocation, ventura:       "2015273d08a201df6fc6ac56708eb142ea6c9a1a1f4fd5c75fec5328bdec6c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17952b03aea70ccf039020719c23f283031de9de00e49883c4847d02a0f9c4fd"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "perl" => :build
  uses_from_macos "expect" => :test

  conflicts_with "pssh", because: "both install `pscp` binaries"

  def install
    build_version = build.head? ? "svn-#{version}" : version

    args = %W[
      -DRELEASE=#{build_version}
      -DPUTTY_GTK_VERSION=NONE
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"command.exp").write <<~EXPECT
      #!/usr/bin/env expect
      set timeout -1
      spawn #{bin}/puttygen -t rsa -b 4096 -q -o test.key
      expect -exact "Enter passphrase to save key: "
      send -- "Homebrew\n"
      expect -exact "\r
      Re-enter passphrase to verify: "
      send -- "Homebrew\n"
      expect eof
    EXPECT
    chmod 0755, testpath/"command.exp"

    system "./command.exp"
    assert_path_exists testpath/"test.key"
  end
end