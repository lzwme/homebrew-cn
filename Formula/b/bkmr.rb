class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://ghfast.top/https://github.com/sysid/bkmr/archive/refs/tags/v4.28.4.tar.gz"
  sha256 "572657db08b817db7a88900843bf42e01b5be8fe386df2d86229e754beaef1c0"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "170cc35dc15eec09751154a73e9dc3e97998f529d78273e6f9914db19db2eb65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29fde95505cbea02839f623628e5c45bb5d7542200155907fb0f326c96698694"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df3e5c8520175bfb80e04db14468cf594875ff037a7a10958a9dd1590997a056"
    sha256 cellar: :any_skip_relocation, sonoma:        "07e0e6929f02b110922654172ef76be85312226b41bc66d8f2316438f3d1e8e6"
    sha256 cellar: :any_skip_relocation, ventura:       "e30fe265a6a0e39e8dcf664707f25fdcbfafc7b31832f91a2bcd36cae03381d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "710e3349e995bda8fdaad10b843a277d7438b63f776f0382a2e200b53262ece9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccb7ffbab0dd14d079b9c65fc68aa248a9730677a52e842bd643b869ba288eee"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    output = shell_output("#{bin}/bkmr info")
    assert_match "Database URL: #{testpath}/.config/bkmr/bkmr.db", output
    assert_match "Database Statistics", output
  end
end