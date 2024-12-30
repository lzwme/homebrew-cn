class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.24.tar.gz"
  sha256 "d7dd54a68c05d3a6ec25aa6b5dd04a971398312ab4b750f1a3457e1fae9b6dfb"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "713425e46459388de80ee0052e6296133e94120f07f53e0d1fef61a4e32099b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93a8dbf0188d0cbd09595f17adc18b3ffb9ab0899cd6c4bf9451fee4ed2f93d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e26e39e35f5e44d2a67569d89b43dec7554c9259125f6c5e13a20537d4954a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "79226754f53a60d8309e4f6ca9c9106dde139fb42dcd2dfedf2ff1d6f3b63d0a"
    sha256 cellar: :any_skip_relocation, ventura:       "d5a6aecbb8257443f7136433cd1f83ef469ff14551c2fd90745fd593adf02bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e467b2539e258347a6cf92562f6f41d53c746fdce90577f96365a933098beb4e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    rm_r(buildpath".cargo")
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}geph4-client sync --credential-cache ~test.db auth-password 2>&1", 1)
    assert_match "incorrect credentials", output

    assert_match version.to_s, shell_output("#{bin}geph4-client --version")
  end
end