class Ad < Formula
  desc "Adaptable text editor inspired by vi, kakoune, and acme"
  homepage "https:github.comsminezad"
  url "https:github.comsminezadarchiverefstags0.2.0.tar.gz"
  sha256 "7bb4aba27b34e0eb0814bfa14c3b6d87a0c411e8ae12de2c62f76f23ab358a70"
  license "MIT"
  head "https:github.comsminezad.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0362655e5d1c192e376fd56ee567e9be2433ed3249cf63b5eaf259868869b3b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88017d42ccdeeaf111e0f739ccb8dedbb61c4279525c861bb55398aeb931541c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "178214b5293b70bacd98ba7d2bd5577cb951ceed7aadde102240c9032c1dbc8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a40d1565fa03746e07bb1ab5fd968fc3f350c711093460b8246f6d619402094"
    sha256 cellar: :any_skip_relocation, ventura:       "164bd7e2ccd5e4fa23f170f9aef09e1b6fee344196e1503902b67e9142db31d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95139e4a509983eaf89866618c291300b10eeb2ab196012c6ae758aba5feab16"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ad is a gui application
    assert_match "ad v#{version}", shell_output("#{bin}ad --version").strip

    # test scripts
    (testpath"test.txt").write <<~TXT
      Hello, World!
      Goodbye, World!
      hello, John!
      Hi, Alex!
    TXT

    (testpath"hello.ad").write <<~AD
      ,
      x[Hh]ello, (.*)!
      p$1\n
    AD

    assert_match "World\nJohn\n", shell_output("#{bin}ad -f #{testpath}hello.ad #{testpath}test.txt")
  end
end