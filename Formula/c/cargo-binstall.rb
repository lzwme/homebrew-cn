class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghproxy.com/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "7715befe4d52c09d93b7e4c98a4a8258529b862b30147de7e0c97808a93a37ea"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af0025d4b4e6150f59e81f4eb23aca300dccd005830dc9d247ae59d2a4232c27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfd5fef9e5825927750a99c5dd3610855d5c983da0ae97b1e8200c0ec1f462bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7472d422ecab3f737b224eb9003cf6f2bdcfb0e2af87bf3c17d0e09acf9a28f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "49d4d6f0df328665aa112829055a7d45fa8997f789bd9f7769adab7472c6399b"
    sha256 cellar: :any_skip_relocation, ventura:        "622d695bc097bef72a56624929d96fa0981fe2561d45dc57acb8747d6c29a04b"
    sha256 cellar: :any_skip_relocation, monterey:       "68f0f5614985482f3ff7864733e5ded9fbc31cbb6823fd49b1403721fcc0379b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c54764b1a55ba5bf607844ce51eb71bd1ad4832a47a8fdb46b32eb984a5a17d"
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