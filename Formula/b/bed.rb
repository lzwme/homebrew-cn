class Bed < Formula
  desc "Binary editor written in Go"
  homepage "https:github.comitchynybed"
  url "https:github.comitchynybedarchiverefstagsv0.2.5.tar.gz"
  sha256 "a8fa1bddcf65fd3dd52ede2f3fc1cb2840420e9a24fb8fd8c950a9bab9d86f70"
  license "MIT"
  head "https:github.comitchynybed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eb29ee4f9d369143a3177e52c4e6e412e76baec765ecf20f16334f117d5287fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb29ee4f9d369143a3177e52c4e6e412e76baec765ecf20f16334f117d5287fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb29ee4f9d369143a3177e52c4e6e412e76baec765ecf20f16334f117d5287fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb29ee4f9d369143a3177e52c4e6e412e76baec765ecf20f16334f117d5287fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c23fbc4983730757f05f06f6e69250062e291f945efc4433b051a285d2ec342"
    sha256 cellar: :any_skip_relocation, ventura:        "9c23fbc4983730757f05f06f6e69250062e291f945efc4433b051a285d2ec342"
    sha256 cellar: :any_skip_relocation, monterey:       "9c23fbc4983730757f05f06f6e69250062e291f945efc4433b051a285d2ec342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d12893a697b18fcc08cff0db017ddffeb5754f7e514a6d8cdfc3b81665936a22"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.revision=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdbed"
  end

  test do
    # bed is a TUI application
    assert_match version.to_s, shell_output("#{bin}bed -version")
  end
end