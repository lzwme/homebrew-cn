class Ares < Formula
  desc "Automated decoding of encrypted text"
  homepage "https://github.com/bee-san/Ares"
  url "https://ghproxy.com/https://github.com/bee-san/Ares/archive/refs/tags/0.10.0.tar.gz"
  sha256 "18bf57d57deafcfb0250b49c9a70380cb1b959971a10285ccf8205c5b7f01e24"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91d1b11bf4de703e618bee7fba2aa7926df4460d7add733014c9dbe8367ea916"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa6ed1d1c354b1285598b000169fef7b487c8cb9195aa9bc38f11e6b471d1a71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "219856d62d0547d05c2f42ea16f38ddc9b3cb7c7a0f6c20d29dd7a8074d63b79"
    sha256 cellar: :any_skip_relocation, ventura:        "d6400c47a87aef54def75493e1cde52c6804ca6ad1818db2014e9a25751533de"
    sha256 cellar: :any_skip_relocation, monterey:       "0f90a8479e2ea290a3e51fe8a7736d08c65019954174c8907f56520bd224ef49"
    sha256 cellar: :any_skip_relocation, big_sur:        "b41b51bc6280bf6626c35eab38e92a4d3b850901a0c0792b9a5b23cdc8edd0af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "821c633fe444336330026761457159068542bd03aab04bcec7d80d2d29e9ac39"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input_string = "U0dWc2JHOGdabkp2YlNCSWIyMWxZbkpsZHc9PQ=="
    expected_text = "Hello from Homebrew"
    assert_includes shell_output("#{bin}/ares -d -t #{input_string}"), expected_text
  end
end