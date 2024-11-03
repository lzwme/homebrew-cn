class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.6.10.tar.gz"
  sha256 "7b8e02c28976606cc7f40fd7fed13ea05a93f4fb1b6d9fb3d1a91f28cf94e7cc"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f1519d0628c46abdbdc4c6bfc5e6ce711055f91c389316de5cc47b9e8420c90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7dea6217d6edeb4477d77722d0f00273c32e8be7ea55fd5434c4cfe9235e154"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cadfaa9cdd47a136d9a30c6dd1f86275323525fa97f82d71dae0528441bd2d1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e29b6bfaa445ecc75abdb949640e03219fa6d3699a4dbd7646220447754622d7"
    sha256 cellar: :any_skip_relocation, ventura:       "430a2e354c730c8115644636a6c169983155f3081c910c02323dfec0fa57652e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f48fcb62c454c2bda3a20d9682f11fc3676a16a8ba71d719d66382e52be07eea"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ox is a TUI application, hard to test in CI
    # see https:github.comcurlpipeoxissues178 for discussions
    assert_match version.to_s, shell_output("#{bin}ox --version")
  end
end