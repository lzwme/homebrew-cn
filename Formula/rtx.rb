class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.27.9.tar.gz"
  sha256 "c9cd5b2176540942b9e53860f661da1dc06deefbf858561631179cf0be112e9e"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c3447946f43e8303cd18d29904a419f857d561437dd7d9620862e6e84236fd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "135a0c9238e8d0706608c2f30a028307d032591c60443f484a4210032e6593e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcb057b36cac043cb4ea96c487e28c0bfccc8e7ebce9e41ff92fff28869b9d57"
    sha256 cellar: :any_skip_relocation, ventura:        "e44085357ff9f591f8927358d2ad668114c857fcc0b275f7e2e72d0253843a9d"
    sha256 cellar: :any_skip_relocation, monterey:       "c732acb89a76c1fae787e7a2a3ff3fe98f416638b792c493c73ba8183550f0e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "62392ae979bedf0d2ec435bee62b97985c7daa337e2a995dee5b22cae332355d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc62c18e1f5b2a7c6dac2457fde26d6f50b7e0301557f855c7fa8edfed28fef1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end