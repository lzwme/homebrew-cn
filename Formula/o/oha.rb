class Oha < Formula
  desc "HTTP load generator, inspired by rakyllhey with tui animation"
  homepage "https:github.comhatoooha"
  url "https:github.comhatooohaarchiverefstagsv1.4.7.tar.gz"
  sha256 "a0fa13d33a5607f3ba4321522d0b2626a0eb52c94471e26e05350cd25d15d2ec"
  license "MIT"
  head "https:github.comhatoooha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43380667267790b276fe627528eca97d65be2d932240f55f935f608b006e0c60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8896d0ef753755d0353dad8c5556794d19e5182705f229666290176f834bca00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1765667154ed80d52ef0d56a2cc563d36bfebbfdd4418683ec318f5fb89a788"
    sha256 cellar: :any_skip_relocation, sonoma:        "8243aecd2e6523793241ebb533484944be33a6e13e8f8d8dd11f4b442f3e4e34"
    sha256 cellar: :any_skip_relocation, ventura:       "f6825127a9b9b3f5780cc39da3f626b38f719571761cd35c305a014a45c957c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1374ac88a0ccfd989e5ca5f8c53d9f039d812a5ece625ba350710f10df6e0e3c"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}oha -n 1 -c 1 --no-tui https:www.google.com")

    assert_match version.to_s, shell_output("#{bin}oha --version")
  end
end