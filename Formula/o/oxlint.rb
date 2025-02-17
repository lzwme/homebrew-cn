class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.11.tar.gz"
  sha256 "02a3b2a10856e12adf84ef6a7ec8bbd7d06d6203d063e4fc0fb72b42ede15267"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48dc031249a9d5c8f35943c4f80e1a19395caad2434ec81a932484d947867d39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd9cb6d5f15d56732846b3623b7fd384a1bf9db852eae096cc9db665a6eab52a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e069d213076e6163e7fb1f40e8fa0553b93159a5d3b43f3d2ecb3a7607716770"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb45e308cd999f2a7afbeb1db341276f156c407d3c44929a4a90acee509b8676"
    sha256 cellar: :any_skip_relocation, ventura:       "cbf58be593e4d44d85850fae62b4e1c0729cb2c23a563994c44b5c447ec7fbdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1609ed929530b341004d9472784bde57a1af147b393f34a33627f0dea76cd488"
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