class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://ghproxy.com/https://github.com/launchbadge/sqlx/archive/v0.6.2.tar.gz"
  sha256 "d8bf6470f726296456080ab9eef04ae348323e832dd10a20ec25d82fbb48c39a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e4901201ba0a070e8e6d89c5a79dad091b5c683de4682b10de52fa65549cf3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5153d0b8338a833781b23861e68d1262e391ae3a32492a66ecd3a02d070edbd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ce6f164581fa51b9d4797bfd8def06d86b4de9451ebc423e7a68e170c893cc8"
    sha256 cellar: :any_skip_relocation, ventura:        "188ef7dcab83d604e53efec308b34a1d1050f822c482f421313d8d4feedcaacf"
    sha256 cellar: :any_skip_relocation, monterey:       "6f611c4dcb4d55530045d4b8fdf046198809c845bdeb05260fd112efd4970d75"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f2b4014f9e23b3c8216374bca8c8b2ed6917c3d920ff5c1f824472062704685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02dff02d06fb0bf0f3ac0aa961822c5fec25612b3edad2788f20eb6a847f447c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  # fixes https://github.com/launchbadge/sqlx/issues/2198 for rust >= 1.65
  patch do
    url "https://github.com/launchbadge/sqlx/commit/2fdf85b212332647dc4ac47e087df946151feedf.patch?full_index=1"
    sha256 "8f72bff76a88e5311aa4b83744a509ba0ac4effa9d6335ba3986ebedfee6051a"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "sqlx-cli")
  end

  test do
    assert_match "error: The following required arguments were not provided",
      shell_output("#{bin}/sqlx prepare 2>&1", 2)

    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)
  end
end