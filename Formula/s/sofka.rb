class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.29.6.tar.gz"
  sha256 "b642d5bfb4172b41e82e4d44cc9d881cdb3a7f04070ba9fbe3735f17d4885d77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "294a2b37b3bd878afda6b93e27e2089b832204296f8681fe23212912e7bdc538"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93018ae978aa93e4cf1d458329509914d9782ba1e3a2de10ad6e66ad6c11355b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b365409b62d68328ae19bc353133fb278814fbc04808f2fb7c4aac779145061"
    sha256 cellar: :any,                 arm64_linux:       "c7e21889a8b674bc8ddd24ef28aacb470357e66ae676b571d2f35885a864a9b5"
    sha256 cellar: :any,                 x86_64_linux:      "cecd3a69c0dd0fd43bbede796089ad692f4e3be5d801960ed6b26e19782d9673"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"sofka", "completion")
  end

  test do
    assert_equal "sofka #{version}\n", shell_output("#{bin}/sofka --version")
    assert_match "failed to read kubeconfig", shell_output("#{bin}/sofka --check 2>&1", 1)
  end
end