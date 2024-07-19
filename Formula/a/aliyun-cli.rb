class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.214",
      revision: "635d1d3df297be8215e4c1b33ba5ce9f7430c6df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4134a878ebc42ac09ddb67082e49951f860c3d741f76d339da20ee518a47422"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91484feeb83f3bcdeba3220efd8b3444805129d64d4554f64e308643482282ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc14ad9f21dbde3d42b0c942d9f743005d946920e4ed5570cabb614b03a708e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "32ab998b66eddda5be893888c0741ae7b5cfc3386228156bf9faf2e24cf8d03f"
    sha256 cellar: :any_skip_relocation, ventura:        "d8a9aad382b74f7bc970d63593cffe698fd0d49b8cbb529736b74ce14dea30a4"
    sha256 cellar: :any_skip_relocation, monterey:       "0136bd0dd73d200b9fc940ae5166b32d6e9fbf7cb63ea2ab0176127de354200b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89377f25e3c5b6badd49667e2eb290c54545c436cd02f001696aecc62f7240e2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-clicli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin"aliyun", ldflags:), "mainmain.go"
  end

  test do
    version_out = shell_output("#{bin}aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end