class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.3.1.tar.gz"
  sha256 "1936a5a9bd4f00c5770f40c110ef6353076dc08b91c6dbbca53773b00dc0a537"
  license "Apache-2.0"
  head "https:github.comkubetail-orgkubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3894811ee6f71707a4abe28ffca9318012740550dbdfee8c06de637ceaf8a510"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61b071b69a1336ec145ee55e43c55441fa900cfbe0993e58ae4adf7c80674da4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25b0ea22701632f77cde65f88d644dd5dbe37c8d50a4464dffa1dea330f7de16"
    sha256 cellar: :any_skip_relocation, sonoma:        "17d7500b70aa617ca1257688d4bfc01720dbc01c82bafab376d43b1b0b7a31c5"
    sha256 cellar: :any_skip_relocation, ventura:       "ed9d94214852a9aaa3da299168e14e2a6037dbf9cecf572220ce54ca3611f345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "754254712df74864e946c9dcec1b04fa10596ee8b4a5870447660eed1b149c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53d4889296050094677f734796f3efe101989f1dfc8cea15a521afb9f12f37aa"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "binkubetail"
    generate_completions_from_executable(bin"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}kubetail --version")
  end
end