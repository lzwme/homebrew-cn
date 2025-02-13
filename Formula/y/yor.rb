class Yor < Formula
  desc "Extensible auto-tagger for your IaC files"
  homepage "https:yor.io"
  url "https:github.combridgecrewioyorarchiverefstags0.1.199.tar.gz"
  sha256 "1852cfd744d3680d60e3af045e5129d2a714079f0707c39898d4a81040f81645"
  license "Apache-2.0"
  head "https:github.combridgecrewioyor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "add161546ea037ca791427da0e8970f296b353ded3647123f58be512171a9509"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5ba4db629f59e900f0a7b752a37248bde740abf02f51253db305d9915b32280"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aba57a6a7dd44edbf2e1c0809e9e240c11cb59e811753695e6f047fe1fb6428e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a21fd35f91937dbd3d27bc4d22c58e23c4bfe9996fb378819d31746b8864ad9"
    sha256 cellar: :any_skip_relocation, ventura:       "8ebec36b59a55e788f79adfebb6c1af2649fc5f8fb1aaf23988f69d86f6ad95c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46f04666cd4d097b5395e4516d2bb396f9c868dce659571054e503926eb13e33"
  end

  depends_on "go" => :build

  def install
    inreplace "srccommonversion.go", "Version = \"9.9.9\"", "Version = \"#{version}\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}yor --version")

    assert_match "yor_trace", shell_output("#{bin}yor list-tags")
    assert_match "code2cloud", shell_output("#{bin}yor list-tag-groups")
  end
end