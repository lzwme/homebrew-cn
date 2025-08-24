class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://ghfast.top/https://github.com/sysid/bkmr/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "e419077c9d8ad8df0f129aecf3c36b10471ccbd9dda1f8be71ef5901050f5d7d"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7c94a2e29c187d7ff65cdbd80b87264fbd43162491f197ba909d6e48a142a12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1576db3ae7683a0c8a007a3b26507123b829b161c66580ae16861648969a7494"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a17ba46a8ba2cf2bb1e5005967018f1589586b780388742a2dd614f75d37c0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9c04c067a2e5223a6de3aae855c984ef9375382143c2c10ef20960778cd38e4"
    sha256 cellar: :any_skip_relocation, ventura:       "45cfda4075cb58b2e66f59a5ee79a5852800be20cd7c3687bce05fbca88f02ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d032b92ed1a0e99e7d92cff6f0d38ef1f9b8f95e02ca2f161e5862ededdbc8fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58d0a3ddd8b81f8fd8048ecce8ba6f967c01573618fecf20c7876b8e45e2a516"
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