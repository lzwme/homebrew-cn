class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghproxy.com/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "5c13fd2faff196563cbdaee0f2fa13be3ac8b1ed3910cdb894795eff201d8f27"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdb99b7dcbcf499967075608a25029e6b36bbcb6c8e73b9f3b6f8602b9d59f5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8edc54669c67eb711e549ac84ac63ad2270a678d8116be651de3efe3f7de9f8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "559d0ba07e540f30d48b6d9fb353632a8727105d8ddbecaa369ddd0fd33aaa57"
    sha256 cellar: :any_skip_relocation, sonoma:         "018e8d5d75dba1d32a54f945021af3f979696e1a0aceb02f5b08307668a8de7d"
    sha256 cellar: :any_skip_relocation, ventura:        "531fc8058042bb7db8a0593bf36bcafd5dbad081311ce4264ebd5755a6b26f82"
    sha256 cellar: :any_skip_relocation, monterey:       "578448e4d68c9fa23ca4a549b173522d63071eadfc36256e9c194166c6d9a67d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5015c7bb5c4278b7f313fec2044b4bc6e851ad979cfe2481894ed3e4716afc5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end