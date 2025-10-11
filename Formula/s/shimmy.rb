class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://ghfast.top/https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "2a57ca267673b98124d6b23566c15cff45951ecca5f44c610d24751e09665f46"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78496ad85ff14a42e6332d1ac7852b8400238d9bed2652f6c2c3b8ddd073abb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "990fb4c439e611d272885716a71c0787d0e75dacc6c8d4a727a9a310dae2685a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f1db1f8ea62f555da9764f7a1a1abacbda035e34e521729fde8887ec49fca16"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f8dbc62493edd0b3d9816bc59aecc1f3c3e6b8d5e6f64453cccb69a4d83799a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8a5f88cdfd113f59c2fb1e3093d6402a3303b2d5010daf04807c462fa057718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da02c8841d3435387bed82a6062ac62bd570134e73abbd4940ba5da7fea30419"
  end

  depends_on "cmake" => :build # for llama-cpp-sys-2
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"shimmy", "serve", "--bind", "127.0.0.1:11435"]
    keep_alive true
    log_path var/"log/shimmy.log"
    error_log_path var/"log/shimmy.error.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shimmy --version")
    output = shell_output("#{bin}/shimmy list")
    assert_match "Total available models: 1", output
  end
end