class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://ghfast.top/https://github.com/sysid/bkmr/archive/refs/tags/v4.30.0.tar.gz"
  sha256 "21721d38f740d6470931b7a414e832187788fb090220eecd01de590e7c57a281"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9ff1a2f6bdf6d24ac0154257215602c7d92bc00efc120941b0cd9ec9e27acb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "071fc4438c67b9018e6f1fdaccdf3d30e47829f9435923f0ee6c8da454e1518c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fcbfe11f2e73662a87d8aaa544e8ba1103de22876393992325e465d95d3e0f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a0c9cc3b61c4336fa5d935633c9736fae4a064473c76d09cd61bd43df170129"
    sha256 cellar: :any_skip_relocation, ventura:       "e9fe805693bfba540bc43c0e670ef29c2346a654e261b9954d7efc2170ae2995"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7613828396ed78d21ab10f0f257179021e4030a3d7d2be3363fad2b04e10648f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a112493ce8c4687bff50f57f3e2288c2ea66ab18fe7469d8debbb1ec05f0053c"
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