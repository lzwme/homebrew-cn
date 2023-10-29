class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://ghproxy.com/https://github.com/geph-official/geph4-client/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "5a38acd5b39ab411e7aabeecc24652f632b3cfb91a699501a4de7581c58676d0"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80c7fc5541e46e342fc3e2b7a438416649158c0c9107ad8abc3bff680c65c1be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c81d7af3699cb7b55fbbe8f00088c3187c6b6d2ac7ccaa8ae4458f0d0fc63fea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "229739725782785899d794305b55f6fdac16150698be283ecc4f8926885234c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "663a021bbff49ff6d7b017a249c56991305fe815d1ec745fe56945268fc3cdd1"
    sha256 cellar: :any_skip_relocation, ventura:        "23ecb09f8107ca39c05d1a8b452a53333f6d98ee67579b35ffa02ddf742ac263"
    sha256 cellar: :any_skip_relocation, monterey:       "3dc145b3daca57dd02decfbff19a205a22271f3dd8e6505bda15880b647c0b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a1ed4984afd9af4fdaddd4122720444e0430c3c025d9b841492c82a6a82ddce"
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

    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end