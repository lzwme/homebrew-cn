class Chainhook < Formula
  desc "Reorg-aware indexing engine for the Stacks & Bitcoin blockchains"
  homepage "https:github.comhirosystemschainhook"
  url "https:github.comhirosystemschainhookarchiverefstagsv1.6.1.tar.gz"
  sha256 "00806aec182bf14be9d3cad722dafc54c16cf7da9db9c885a89469c03c92545b"
  license "GPL-3.0-only"
  head "https:github.comhirosystemschainhook.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "050f80990e4f76d9b90364cb09fa1db3dc5c6b61d57368bca4b9ad518a8def96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b46a82f9894a34b137d63a646e360e010f84a9c2cf6b6f7f513b5a3fc4466c7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfdeef245d82998e1330e264becc33c7bf2c70bdc020c313c0d14e3731e6fa00"
    sha256 cellar: :any_skip_relocation, sonoma:         "65b51217f673bcdb1d50bb04cb6f2bcf1867f24fba2b14552b4fb015146f3314"
    sha256 cellar: :any_skip_relocation, ventura:        "165f9376423bb30608a46ce02760d061ac1097c065961f809a8dbb51821e44bc"
    sha256 cellar: :any_skip_relocation, monterey:       "ee193ac87ba6381f885fca48065a58cd7f3b7ca7a1e89f1d9548e7d21f8b8646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "300bd18d279e66b3abe3e1c1b2018c87744cc15d3ac559a148d2885a731b79a3"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", "--features", "cli,debug", "--no-default-features",
                                *std_cargo_args(path: "componentschainhook-cli")
  end

  test do
    pipe_output("#{bin}chainhook config new --mainnet", "n\n")
    assert_match "mode = \"mainnet\"", (testpath"Chainhook.toml").read
  end
end