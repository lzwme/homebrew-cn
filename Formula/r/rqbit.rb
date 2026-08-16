class Rqbit < Formula
  desc "Fast command-line bittorrent client and server"
  homepage "https://github.com/ikatson/rqbit"
  url "https://ghfast.top/https://github.com/ikatson/rqbit/archive/refs/tags/v9.0.0.tar.gz"
  sha256 "a5c549c35e5a1e643e67376fd465158421a57e600594b69438f444b804fb6f34"
  license "Apache-2.0"
  head "https://github.com/ikatson/rqbit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ea18b3c71572ff7929eec91eb4fb7920125b3e80ac1194643bcc0c06578136a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbd898c38cdf10af068948a14fa0611607699b23789109d8a6c4589851e55a17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d955ab06760962d9f546ee8a4d56c8729e1f8cd9e72e5bb8079555c7a0006181"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee5092fc4be98c9ba6b60d61d8c180d4f314b82990ed74c30a87ba3ba0b879aa"
    sha256 cellar: :any,                 arm64_linux:   "7d0eee71de9c9104343f7661fb6cd92c3aa14c77a71c507725a3e3d0ae28286f"
    sha256 cellar: :any,                 x86_64_linux:  "07ff34ad28683b1492e609e23ee7f90269ae91a93c2b50c134dbe1ebe8fb04de"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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
        formula_opt_lib("openssl@3")/shared_library("libssl"),
        formula_opt_lib("openssl@3")/shared_library("libcrypto"),
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