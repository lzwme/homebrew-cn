class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "528b02ed18f35f556722218c536a10acbc484f64e843a426e8f34dd50b7fa531"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a13a553d082095d87fd049372afa7344685d532420ec739e54abbe9177981086"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2fa315d30dd244bb8aa31026c55707de0904cb73fcbe66d244952ba10afb5193"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "979ab845f7953f0ba41eb35bdda0b33bfd4c496c0662b57fbcf9d135713c64f3"
    sha256 cellar: :any,                 arm64_linux:       "7adfd67f88a6333bcf21db4d92c33114dd4364b3253bf080938b225d20753fff"
    sha256 cellar: :any,                 x86_64_linux:      "cfcdaa729a0cfd6d95d2dbae8a5d39fa24e2eb0e0c8180e4b3e6f499c9a435c0"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end