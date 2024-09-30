class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv0.8.4.tar.gz"
  sha256 "7f1a0fa1442bd6e09c4e471e0f62c129cbabcdf6050e3e69c0ad3780e6b93aca"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cbafe56f4c76327b2e746d7ef8246f5c7d44d0b5ef67d3402c1960255479fb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b35c295f8daf4fa29581f2db2abc150852904dc40ff86c04b89fb64d3d39097"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efd823995d97dac25d582ac7817ff8692eec7845c202fcff3601374faf00b554"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ed192b30d2c756bcba2199c646b8e5c32beb00ecfb10c824584d051bd54755f"
    sha256 cellar: :any_skip_relocation, ventura:       "318589cb743138493a9ddc96ced68ac11a10f9510b3c0501f943489a001d6467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c10ac4f297776fad2e03a82e61b42cee76ad8a508aa02fffae89d3a4468081e5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end