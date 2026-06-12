class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://ghfast.top/https://github.com/omerbenamram/evtx/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "cb1e040d632d50a25f42901279aca1c709d366c8d4334342190561e0d4bf9696"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b195fd2fa5db3af5f8525bb22c543fd69eee6353abc2ecaf9c1dccb9814029f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d86ba072036ccfba02015219988916d5b5ced6b92d7fd84eac03c7e98f24923"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "118cb1cf2bde5c4986039d32c07f52e89e2a800ecfd9dc4adc6f02f09faec6c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6ba9228a6df764819a9e1ebaf4e0433b399b5aaf8b45fcf356c5ffb463cf1f2"
    sha256 cellar: :any,                 arm64_linux:   "3af84ff75be03b8a392eb78556c229965a2ccac7da26558fc722b1313ab11a6c"
    sha256 cellar: :any,                 x86_64_linux:  "b35e9def6e9e16841afa79a4db058e28e816f3b9d9b0b516f60c9756b9d09b16"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "samples"
  end

  test do
    cp pkgshare/"samples/issue_201.evtx", testpath
    assert_match "Remote-ManagementShell-Unknown",
      shell_output("#{bin}/evtx_dump #{pkgshare}/samples/issue_201.evtx")

    assert_match "EVTX Parser #{version}", shell_output("#{bin}/evtx_dump --version")
  end
end