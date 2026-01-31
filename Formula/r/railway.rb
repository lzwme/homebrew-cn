class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.27.5.tar.gz"
  sha256 "ef0cc539aadd40cf958db50f8a551d0e649b424c2e17571b16e973d3e442a80b"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5be32e362d4230800eb42df9cefe6ca15fbfd8ac8d97de22a2fa773b55703f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5895c3ae482479966f4a93d730696c964fc18660101e0174d23c3c141008a880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5af0107e7c5554e07ea108a49e19ac4775e573fca745d708a21c668748cbee5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a27a96b0e7dfbd520b7fc8844b74dac2840e078473576bdb46ed7bdcb29c0bd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba84b80d3bde313dc6a149bf24d91caaa743bd4a5417773c47ff2d23caa03ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e2d98066067d29733fb90240b34ea7d9de836ecd94814b71dc0d7aa9190ddde"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end