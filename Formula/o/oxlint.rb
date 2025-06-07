class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.18.0.tar.gz"
  sha256 "9d2f927fc26152b10fdceac426c8ba87ec6bf5d7a958fab9b853886eea916b3a"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69f52ed41233eac2c900381457880bd273ae1d809e1aa7da3b148ce1a7559bd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5a466d110dddd82394c03686955e78706d8a61730d77d3f34d98aef919c02b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33141377685d7ae831339c48ed78a2a9622a517ddbfac88beff1d43eca1e1651"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee7786c3145737abc2baf3a0c48ebdd63e24f17581abee882694db2ac53e2660"
    sha256 cellar: :any_skip_relocation, ventura:       "8acebbc3c654db13173eeaf5e8616e529d281be6984becc182a98ea066f92997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79fb0290a23bd04370f5380bb9605c17771008896b628d583a292b329f54bf3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d25eb74d72c3efc2f901f6ee665212db23c2c7322d7c0a5ec67e254d8c1a50dc"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "appsoxlint")
  end

  test do
    (testpath"test.js").write "const x = 1;"
    output = shell_output("#{bin}oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}oxlint --version")
  end
end