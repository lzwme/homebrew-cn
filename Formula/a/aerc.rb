class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.20.0.tar.gz"
  sha256 "1a7d6172b5740ead40bf1400cd45f00400822bb6af00aef76d04b386a4292d8c"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_sequoia: "01922973c2a9418fd50f3a95d9a9522dcc58b13873988518cfe7fe1ba13d4a65"
    sha256 arm64_sonoma:  "56672bb5bbd58e3923b2def092f2d4827b3e4d3a40a7825019237e7bfdd8a488"
    sha256 arm64_ventura: "ec86140a04ec8e7f496da526a6c9317983be06636f3605df8a511690509c7436"
    sha256 sonoma:        "ef7b4fe9c02603776a7164ed05de149f53d3a25c79d6ccfa9ef6d9e38efba4f0"
    sha256 ventura:       "a8fdaf4e23d8942d46d7201ed739c5aea0c62d5c40bba0e70abe67604188b10f"
    sha256 x86_64_linux:  "d33a7fe9dc18befa0caf8892bcc54bf5da711ff93b132d17f047f3529fe2d607"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"aerc", "-v"
  end
end