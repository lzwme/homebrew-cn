class Ryl < Formula
  desc "Fast YAML linter and formatter written in Rust"
  homepage "https://ryl-docs.pages.dev"
  url "https://ghfast.top/https://github.com/owenlamont/ryl/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "062cc0342d33bcce4a105bf22c96d44df862306d03d926a83c2922d2b8329834"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f96413e6cfd105b1084540fcf7bcaeb76b97cda680a570d9b2ad85e0c2cc625"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ddb5acf8849566deb3278ff4a4f7b9d54ad5f08b2fa7ee5425602bafebe56cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "688f1c327ece091b89559f2c63d4f6adf9f9e50d2c99043e462d989e453a3a86"
    sha256 cellar: :any,                 arm64_linux:       "af852438d8d46fb8d596082611b81c553c4be5d17a7a418a7a90f9154411c493"
    sha256 cellar: :any,                 x86_64_linux:      "4131188396525b0485d9ceab0c9105babc832cb279061d6d58d6e50421f7403f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ryl", "--generate-completions")
  end

  test do
    (testpath/"valid.yaml").write <<~YAML
      ---
      ...
    YAML
    system bin/"ryl", "check", "--enable", "ALL", "valid.yaml"
  end
end