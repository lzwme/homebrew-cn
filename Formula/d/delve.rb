class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https:github.comgo-delvedelve"
  url "https:github.comgo-delvedelvearchiverefstagsv1.23.1.tar.gz"
  sha256 "52554d682e7df2154affaa6c1a4e74ead1fe53959ac630f1118317031160a47d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f830283f8e3efd8131e88774f925994e007821c553063bbe89cc92b7c19381b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f830283f8e3efd8131e88774f925994e007821c553063bbe89cc92b7c19381b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f830283f8e3efd8131e88774f925994e007821c553063bbe89cc92b7c19381b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3da45578bc1d681644ba862dc74074cb1b38f2c26928e11bab3faaaac5a7575f"
    sha256 cellar: :any_skip_relocation, ventura:       "3da45578bc1d681644ba862dc74074cb1b38f2c26928e11bab3faaaac5a7575f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c9c726e7f65f686aded93c0cc59ba2933361be5b7f02b71ca7eb79aa831be88"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"dlv"), ".cmddlv"

    generate_completions_from_executable(bin"dlv", "completion")
  end

  test do
    assert_match(^Version: #{version}$, shell_output("#{bin}dlv version"))
  end
end