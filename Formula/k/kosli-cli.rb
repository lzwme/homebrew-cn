class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.11.14.tar.gz"
  sha256 "b38c16a701587c91451c9a3719151907c9c3335e1c51b2216d8e6ae5d4879626"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5acc2fbc94039e0024cef383b6c713fab9df08e1840921649dedd085c2b6e709"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c364e5bc655683168c3b49a17fa5a3983a8b619ed56a0fd9965b0fde90dbd130"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08edfbc7dd9f5a284522beb740e5ef5b9a4928b4048d3ae1c4b5a54d9b25351f"
    sha256 cellar: :any_skip_relocation, sonoma:        "dab9b468a53a11b219b3b9041fadfecafd2350135cb9dd5ee5a365ac8d288aa8"
    sha256 cellar: :any_skip_relocation, ventura:       "46d51d5437cef0844aa6511f3a878ce01f4813f5f81cdb58b765bddbb723293d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dedbb48c919edf8c8e50043e3710eae3e7fcaced7cbba69dd6f106b81cdf3fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fb32d0378078d48ed7e4dbd0b5a8b8d96f6fa48c5e8340d5fc1e19e68e8aa8d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags:), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end