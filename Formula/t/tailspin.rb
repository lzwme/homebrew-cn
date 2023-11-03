class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://ghproxy.com/https://github.com/bensadeh/tailspin/archive/refs/tags/1.6.1.tar.gz"
  sha256 "244163902523c9350658dca6b9e74aaddeb7635bd9195e21f8cfde0b62844e8e"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20edcf641bae85367fe507d037d6f5abcf859b225390589a3fd78eb9a4fe7bd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d65a0d59c108a513bce0ca13592989639756639f8cee42b0a0127d0011fed4b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6f61c7336e597f5efa4fae2f8f8871b2b25d816ebe9188814562988987dc379"
    sha256 cellar: :any_skip_relocation, sonoma:         "fef8d38db004a6a616026757c8685d5c928c9e9d71ae2a341893be6661370d30"
    sha256 cellar: :any_skip_relocation, ventura:        "f79f31db9af9ba6b94e52452512724055a50385f51382543642c186898cf871c"
    sha256 cellar: :any_skip_relocation, monterey:       "bc4ca51a46824a19fba0b73f568b0b5d940c5b475a66567b2d149d00a9d3fb5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b13216dbbccaaa97902dd096dc2208c0bcc55b59cccff8c4d078da647244fb56"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/spin --tail 2>&1")

    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      "Missing filename"
    end
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/spin --version")
  end
end