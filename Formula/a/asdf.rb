class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https:asdf-vm.com"
  url "https:github.comasdf-vmasdfarchiverefstagsv0.16.4.tar.gz"
  sha256 "6b63b7b5edc37fb8af9d676a0f7bf2cc3cf449045eef8f9d1bf45b99b42842ee"
  license "MIT"
  head "https:github.comasdf-vmasdf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1dd4007177e58892fae2a75114d7de4948e78ce8a9b98a417e98448953ffeb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1dd4007177e58892fae2a75114d7de4948e78ce8a9b98a417e98448953ffeb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1dd4007177e58892fae2a75114d7de4948e78ce8a9b98a417e98448953ffeb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "66337c0d0e4e7115ded298ec3bff0bf38a92a2c1584161927ca5cb18be43b398"
    sha256 cellar: :any_skip_relocation, ventura:       "66337c0d0e4e7115ded298ec3bff0bf38a92a2c1584161927ca5cb18be43b398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97c2bc741439f811ac0ae93b4595f506e154a745f5075503f4b52543bd3cf15a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), ".cmdasdf"
    generate_completions_from_executable(bin"asdf", "completion")
    libexec.install Dir["asdf.*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}asdf version")
    assert_match "No plugins installed", shell_output("#{bin}asdf plugin list 2>&1")
  end
end