class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "979d4caab3d5c830477ea34311acd910ca55158bfad29223a36c9cd8acfee7ac"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "892f313a66b039f93826e0df1a950905f4c41a17ef636787f2aa542c9f510675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ddd0db51d5c9b17c8560aae2abf5771d25580a4c92334aa807c72a8c7800106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1f6c515ae61cdbc13c112162af0cdd5cf1926ef5ec86a3e492f76057665a1f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "cac9a9ea833fed00993cc031ef1cafe8d4c43d32497f8d8ad5dda03420a66274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe0992ec953512ab74b0b103e30d46fda5f5e83daac0463667b8134f0fb41c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "679848c30534eeb4d9a58cdadc511c7b127fa0af5888e46352e8e66eebc7e766"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end