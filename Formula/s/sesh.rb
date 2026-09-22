class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://ghfast.top/https://github.com/joshmedeski/sesh/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "493cef6a9e48ddb12ffb0855d54f734f6d440073f76168820a495d5196852996"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "701499d6479a0c6d329997b29d569d98a19f5294c61ff5ba830e84a81059543e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "701499d6479a0c6d329997b29d569d98a19f5294c61ff5ba830e84a81059543e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "701499d6479a0c6d329997b29d569d98a19f5294c61ff5ba830e84a81059543e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "56aeb92ca034f3e7a19a666e7437daa17fb06915a730cbc47e2192a9156db24f"
    sha256 cellar: :any,                 x86_64_linux:      "0f1ce24ce87d1ca8cec2a7391ec6a0abf4d57c45b024da74bdda31dfb1d96893"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"sesh", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end