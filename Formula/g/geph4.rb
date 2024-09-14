class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.3.tar.gz"
  sha256 "bedd8dca96a5e5aeff208e44c113d8a4fb97ad0fe7ac83e9568c13236ea348b5"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cf94f4739a3c4ca46076916b1e2317513ec0efcd7cc9d6ddc3476c0f279af7b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4468710fe42a9dc7e5b0d034105d93928fe438c504849d58401bca82dee4ffd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef0ca3607b8f78c35e03140ef6246166fd736e43382849fc2e913e4840df56e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aa738af979c77dbfd61a5e61cf303074ba0f99e4ea6a01898215844018fa0dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "956c339dee523e1b3f84f62aa88525240cb533876d7178d96576a8084b409f60"
    sha256 cellar: :any_skip_relocation, ventura:        "5e11e10d21e054069b2f8812938d936cdd273f8475816cfee7a3e63860e1680b"
    sha256 cellar: :any_skip_relocation, monterey:       "6a7daaaa76e27710425189cc2d5e07ef84f6e71c5ada0b0860f336d123969643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e785f5e3a86f74e78228be67c41eee4b82104c34ce6d7f9304a133ebda59aec2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
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