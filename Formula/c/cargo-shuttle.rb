class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https:shuttle.dev"
  url "https:github.comshuttle-hqshuttlearchiverefstagsv0.49.0.tar.gz"
  sha256 "fe13c6a0717edd1d6ec838c6abf02d3230b379083d4daf8f63621d47d1ceded6"
  license "Apache-2.0"
  head "https:github.comshuttle-hqshuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7d7df9f8bd0165fa7dc319a5c292a1963dbbbd02fb9acc9a82be84a324069497"
    sha256 cellar: :any,                 arm64_sonoma:  "e8ea01a46ba6b94af54656b0a97ac89258031a9a364aeb6a92c9cf995132a2aa"
    sha256 cellar: :any,                 arm64_ventura: "d67182c4ef74a39a5dcdf99b2b6cd1405211f098b2a41d2ba7482cbcd954abb3"
    sha256 cellar: :any,                 sonoma:        "562c9bdcb385fb3d89567b28e90bd5e6eb6a7695b88c3ee2b1a5c6ae6bb07220"
    sha256 cellar: :any,                 ventura:       "97723f1be157be4af14ed4d76c82b4fa210a8b1252b57362fce0273654576339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92e199d3de11901d1ebb0d2bb4b475ad9a6d9d1157d858c159773c0bc6b7c992"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "cargo-shuttle")

    # cargo-shuttle is for old platform, while shuttle is for new platform
    # see discussion in https:github.comshuttle-hqshuttlepull1878#issuecomment-2557487417
    %w[shuttle cargo-shuttle].each do |bin_name|
      generate_completions_from_executable(binbin_name, "generate", "shell")
      (man1"#{bin_name}.1").write Utils.safe_popen_read(binbin_name, "generate", "manpage")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}shuttle --version")
    assert_match "Error: \e[1m401 Unauthorized", shell_output("#{bin}shuttle account 2>&1", 1)
    assert_match "Error: failed to get cargo metadata", shell_output("#{bin}shuttle deployment status 2>&1", 1)
  end
end