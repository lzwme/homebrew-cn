class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://ghfast.top/https://github.com/irmen/prog8/archive/refs/tags/v12.1.tar.gz"
  sha256 "a7907f9cc0bc97e5e30a9b215e12329a5d9157509f765263d39fb9f925736fd5"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d146713a99775eb3f10392218d0b95e344ea24060df72d6ff508b6da3ee9ab49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d39ca41d6f3bad25527d547ea30547b3c8c7f1800c911fe5765fd587c8f629bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "382b9d977fcda288ab6a11002dac56fefdfe3fae4282207d3a668edd664eb61d"
    sha256 cellar: :any_skip_relocation, sonoma:        "72fb116eb53e92450448ecc278b06fef5749aee31c94fd424b764630ec247ea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19cbcac3c1eaafd805411b3f66d0419b4e8cd0c9037a7e7c6ac15eb1f3213233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d0f75aaf24ab1019316da3fb8461ea1873164e4f0af00f2ca4605fe377d515b"
  end

  depends_on "gradle" => :build
  depends_on "kotlin" => :build

  depends_on "openjdk"
  depends_on "tass64"

  def install
    system "gradle", "installDist"

    libexec.install Dir["compiler/build/install/prog8c/*"]
    (bin/"prog8c").write_env_script libexec/"bin/prog8c", JAVA_HOME: Formula["openjdk"].opt_prefix
    rm_r(libexec/"bin/prog8c.bat")

    pkgshare.install "examples"
  end

  test do
    system bin/"prog8c", "-target", "c64", "#{pkgshare}/examples/primes.p8"
    assert_match "; 6502 assembly code for 'primes'", File.open(testpath/"primes.asm").first
  end
end