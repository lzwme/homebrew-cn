class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.9.tar.gz"
  sha256 "eb9f2c1c3687f1ec6af3244f0590083549877345a69d55afc36c5394d9d79428"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e8859452c2d906ddeb582e1b6a1767cf70c3ad494ec4c6e380feef1c5d2acee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "259ef0f6403c3a573f201efa3059d360a23b586de4c30c8452e50b3306ed3b39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75b359acd1f7a179132b87926b720199699741dd03a81fd5a30b171648098db5"
    sha256 cellar: :any,                 arm64_linux:       "044da32b7a3475ee75b8de77dd236b9b88d682dc8e3ed6492173b30e8e12ed49"
    sha256 cellar: :any,                 x86_64_linux:      "f59407afd22c60c38b5c5b4632dd2d7b35b7d0a343b6290a4fecd8726b3c908e"
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