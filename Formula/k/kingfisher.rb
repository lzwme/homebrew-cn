class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.87.0.tar.gz"
  sha256 "d07b3e241b74376f5cab88f8130d5fbe8bd908f2bb772f5bb207d6e4b62cd85e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c4241805daf4f3ba102c0a0d45e78207fbbc63eace9e72468dde255056751ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c3fbcdda62a355344d3937c778adc4703ad2816cac99c8deca62c583976807a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e765b3a9fa05f8821c005b81ad3c69c74dce35c7abc6a0fee2fb205e7a277d51"
    sha256 cellar: :any_skip_relocation, sonoma:        "201c0d0f20d39fddbde3e3454d62cf079ac3009ece54515254129a5a571b1a99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de8b27ca47a99e3c927aa9050f930d05adc6365d564e2af8daa5ccce8f402b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13614110990bf4d998f6c52c35ce208b4a7c9e7723bf7e5431e5ce6d605e5515"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(features: "system-alloc")
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end