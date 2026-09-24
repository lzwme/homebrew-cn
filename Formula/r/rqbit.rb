class Rqbit < Formula
  desc "Fast command-line bittorrent client and server"
  homepage "https://github.com/ikatson/rqbit"
  url "https://ghfast.top/https://github.com/ikatson/rqbit/archive/refs/tags/v9.0.1.tar.gz"
  sha256 "62a42c56259b737eea6580b63061589dc9940b145c40991cfff83470aa783291"
  license "Apache-2.0"
  head "https://github.com/ikatson/rqbit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62bb2ae7f7c4e50d60cc0a6451e27c65b52f058fc35c7805eadf0da979c6eea3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b92188a2fe9685b54265af619f9f9f619507bc372b272e452671010272a5a4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e9e0fe8ac528b26d540c2e132b52d2523fbef6492913db129d08b78e494ff87"
    sha256 cellar: :any,                 arm64_linux:       "6a601699eb076c96eaff3d208172ebcee07877becdf737ac5e72e01abcdb651f"
    sha256 cellar: :any,                 x86_64_linux:      "209d4e7c338188f569c1f7a0e4d26e640d4f03649d7936f2070b6bc66aae8372"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    cd "crates/librqbit/webui" do
      system "npm", "install", *std_npm_args(prefix: false)
    end
  end

  def install
    # Ensure the declared `openssl@4` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args(path: "crates/rqbit")

    generate_completions_from_executable(bin/"rqbit", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rqbit --version")

    # NOTE: rqbit uses the `native-tls` crate which uses the system Secure
    # Transport on macOS so it will only link to libssl and libcrypto on Linux
    if OS.linux?
      require "utils/linkage"
      [
        formula_opt_lib("openssl@4")/shared_library("libssl"),
        formula_opt_lib("openssl@4")/shared_library("libcrypto"),
      ].each do |library|
        assert Utils.binary_linked_to_library?(bin/"rqbit", library),
               "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end

    magnet_uri = <<~EOS.gsub(/\s+/, "").strip
      magnet:?xt=urn:btih:9eae210fe47a073f991c83561e75d439887be3f3
      &dn=archlinux-2017.02.01-x86_64.iso
      &tr=udp://tracker.archlinux.org:6969
      &tr=https://tracker.archlinux.org:443/announce
    EOS

    output = shell_output("#{bin}/rqbit download --list --output-folder #{testpath} '#{magnet_uri}'")
    assert_match "File archlinux-2017.02.01-dual.iso, size 870.0Mi", output
  end
end