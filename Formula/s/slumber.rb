class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://ghfast.top/https://github.com/LucasPickering/slumber/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "f781bf8f0a369641d0b6c8e19336be3cb26ddd44c06a008edc0aad6d7b927442"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7652bef7dec5ba7e31a5c1ceba7bbee81e0fd548cfd49e02c4d3b9d9680267e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b39ff8afe4d7a9ad198439e3409ebbc3c27ae01ff8468848563c1bcb3fb31510"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c4b4075667d2b5a45bba6df3d3f6c5691f1c12d5b7bffd4be658dbb89827d6d"
    sha256 cellar: :any,                 arm64_linux:       "2679a3bfd45b633e189ed3aebf63916c9fbeda2ccf51479017eaa8818ccade81"
    sha256 cellar: :any,                 x86_64_linux:      "f1ebf30c3b59694dc651c485941ccf3beabe4716961bb4a0436890da62ff197f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"slumber", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end