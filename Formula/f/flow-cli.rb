class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.0.1.tar.gz"
  sha256 "ec9f8926faa8f672cd01e8b374e3383a61301fe91d6a76ec9ef112b1279ed2bd"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04df4e42b33538b00c1a91863a1729c9a40f76b4a5ead8db00207705ad155899"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbe50b0164f518f5fc933a1d19cd5a8cf22f7de6cf707b59303080b81694067c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4de89cdb89c92bbde36394c4c89e028d1ffadd9c685bb9b2de0ea81dce9e0776"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5b8a8f93484e7b2e127d49557c980e737d9c6edf13eb61e42d4426beb9bca62"
    sha256 cellar: :any_skip_relocation, ventura:        "5941aafd293be2bd820a62052c0c3e19be2f29fabf96c3279e37fd6b8da633c0"
    sha256 cellar: :any_skip_relocation, monterey:       "a2230329f58d59c0ee19b03ce542784415f1de00258b1bfb8377e66869a2bc0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dbcebaeddb3d757f4ceafee1babb19620a52ae86923f5465b6bb28d863c658c"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmdflowflow", "VERSION=v#{version}"
    bin.install "cmdflowflow"

    generate_completions_from_executable(bin"flow", "completion", base_name: "flow")
  end

  test do
    (testpath"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin"flow", "cadence", "hello.cdc"
  end
end