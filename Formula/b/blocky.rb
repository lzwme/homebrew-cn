class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://ghfast.top/https://github.com/0xerr0r/blocky/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "c8d333ac554f69a90111dfedbf4d5abce7da97fc54221025a580a5e094ff5d84"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3e2158aa0ede4a4f8accf5501347fe0298da6be1bfba2e4dec9a8936820682d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a02093808c6316efd0add6b097f4e12bbba162ebe751e40cdeb15a35f7c0f87f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "651b3eeaf12549aadbd7a7b0f76a84f60bfe9731614dd9c4f76853aa31c4ef27"
    sha256 cellar: :any_skip_relocation, sonoma:        "22cf7781fdb8feb0e266a8e9d21823e7b3b467805b9dc655c8acf92ba11b97e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9071f5389b8b2190063ccbd151fdf3b5c9f92024195bffa02927e8b1777dfe70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad621901770ab7cb2e5f849895939f2d5603a67dd0b53f37559ec82260d469c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/0xERR0R/blocky/util.Version=#{version}
      -X github.com/0xERR0R/blocky/util.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: sbin/"blocky")

    pkgetc.install "docs/config.yml"
  end

  service do
    run [opt_sbin/"blocky", "--config", etc/"blocky/config.yml"]
    keep_alive true
    require_root true
  end

  test do
    # client
    assert_match "Version: #{version}", shell_output("#{sbin}/blocky version")

    # server
    assert_match "NOT OK", shell_output("#{sbin}/blocky healthcheck", 1)
  end
end