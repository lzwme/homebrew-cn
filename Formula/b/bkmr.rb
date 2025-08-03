class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://ghfast.top/https://github.com/sysid/bkmr/archive/refs/tags/v4.29.1.tar.gz"
  sha256 "88602aaf184d0dec36c87912324cc1c683395244c8e44509d549e4b014a7b38c"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f09ddcc2427ddd67d4c545f9b1f3b0a63d015e3211a8cb7ee81188f114160a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cc6ba98d02fe18af8046cbec34675d035037e0355518164a109d0318541fd48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8191b2b55ead56e8319e7c895643d3ba0fa30bc34c1edf7baadbac7299cb56d"
    sha256 cellar: :any_skip_relocation, sonoma:        "53e3f8847731511157b45dd037ccf916040ba8043adb1fd097fafe904d5a4b1f"
    sha256 cellar: :any_skip_relocation, ventura:       "67b5cb5329124a43bd844b965cdcb4f782a10fb041a0a74f914f5c7d90345778"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b111f46d181743c4fb56b999d1e38af8eed642717ee5289503d79e4107ce9a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8faac4783c8462c0ea08f51d327bc032ef185aaf82dfe0f1eeda608945ba17eb"
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