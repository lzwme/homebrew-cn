class VulsioGost < Formula
  desc "Local CVE tracker & notification system"
  homepage "https://github.com/vulsio/gost"
  url "https://ghfast.top/https://github.com/vulsio/gost/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "a404f1c0b94cedf657f1cb240787f162ec3c88a3a78aafd659135c0ccc150bd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53341678b658c824ce882a519b3e53fee844eda8cc17c408e827cf66fa2b10a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53341678b658c824ce882a519b3e53fee844eda8cc17c408e827cf66fa2b10a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53341678b658c824ce882a519b3e53fee844eda8cc17c408e827cf66fa2b10a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4358965cfcd5b191a920c289bfda413eeb78be73d30a430f49beb650832f3efe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afcc9d2adbe552152bf11f85db944d85cf78a94cd8672b918c237b4eb3d88d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08bbc289d41c0d91fe50ebba793dd65b2854adc7e7cdbce5845aae3c377b1806"
  end

  depends_on "go" => :build

  conflicts_with "gost", because: "both install `gost` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/vulsio/gost/config.Version=#{version}
      -X github.com/vulsio/gost/config.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gost")

    generate_completions_from_executable(bin/"gost", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gost version")

    output = shell_output("#{bin}/gost fetch debian 2>&1")
    assert_match "Fetched all CVEs from Debian", output
  end
end