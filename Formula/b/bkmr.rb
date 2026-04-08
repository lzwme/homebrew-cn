class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://ghfast.top/https://github.com/sysid/bkmr/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "1830546367001a5714ab8e068dc137932700b42cd1e6ea9c8c0e80f255edbe0d"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "455458134351a15cc58d6e306b81b32890cf221d0bcc44ac52cc3cabc7d86ae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "319bcccc90e457c551d4f9d35dc2393da56c4af1b42bd1a90bcce2a660094b4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8083eabdcbec3903dbb542936bfca399547cc07d7f7ac6de930cb479bfd071a"
    sha256 cellar: :any_skip_relocation, sonoma:        "03aa96e05ba7a3a3aef2142df95858d839846a1ca96d0ca6e74bea7e1b65251d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c57be80461476e14a123cda25bb8b2873fdcb07b8161bec805e431493d1782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fad514b4a4dfb24bbd9e8668d7fe0a677ebcd01efa0826d72396eaff166b45fe"
  end

  depends_on "rust" => :build
  depends_on "onnxruntime"
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args(features: "system-ort"),
             "--no-default-features"
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end